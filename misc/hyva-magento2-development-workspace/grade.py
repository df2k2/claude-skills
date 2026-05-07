#!/usr/bin/env python3
"""Grade all run outputs against their eval_metadata.json assertions.

Writes grading.json into each run directory.
"""
import json
import os
import re
import sys
from pathlib import Path


def grade_run(eval_dir: Path, run_subdir: str) -> dict:
    metadata_path = eval_dir / "eval_metadata.json"
    output_path = eval_dir / run_subdir / "outputs" / "response.md"
    grading_out = eval_dir / run_subdir / "grading.json"

    if not metadata_path.exists():
        print(f"  ! missing metadata: {metadata_path}")
        return None
    if not output_path.exists():
        print(f"  ! missing output: {output_path}")
        return None

    metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
    content = output_path.read_text(encoding="utf-8")

    expectations = []
    for a in metadata["assertions"]:
        passed = False
        evidence = ""
        atype = a.get("type")
        try:
            if atype == "content_includes":
                expected = a["expected"]
                passed = expected in content
                if passed:
                    idx = content.find(expected)
                    snippet = content[max(0, idx - 30): idx + len(expected) + 30]
                    evidence = f"matched: ...{snippet.strip()}..."
                else:
                    evidence = f"missing literal: {expected!r}"
            elif atype == "content_excludes":
                expected = a["expected"]
                passed = expected not in content
                evidence = "absent" if passed else f"unexpected literal present: {expected!r}"
            elif atype == "content_pattern":
                pattern = a["expected_regex"]
                m = re.search(pattern, content)
                passed = m is not None
                if m:
                    evidence = f"matched: {m.group(0)!r}"
                else:
                    evidence = f"no match for /{pattern}/"
            else:
                evidence = f"unknown assertion type: {atype}"
        except re.error as e:
            evidence = f"regex error: {e}"
        expectations.append({
            "text": f"{a['name']}: {a.get('description','')}",
            "passed": passed,
            "evidence": evidence,
        })

    grading = {"expectations": expectations}
    grading_out.write_text(json.dumps(grading, indent=2), encoding="utf-8")
    passed_count = sum(1 for e in expectations if e["passed"])
    return {
        "eval_id": metadata["eval_id"],
        "eval_name": metadata["eval_name"],
        "run": run_subdir,
        "passed": passed_count,
        "total": len(expectations),
    }


def main(workspace: str):
    iteration_dir = Path(workspace)
    summaries = []
    for eval_dir in sorted(iteration_dir.iterdir()):
        if not eval_dir.is_dir():
            continue
        if not eval_dir.name.startswith("eval-"):
            continue
        for run_subdir in ("with_skill", "without_skill"):
            if not (eval_dir / run_subdir).exists():
                continue
            summary = grade_run(eval_dir, run_subdir)
            if summary:
                summaries.append(summary)
                print(f"  {summary['eval_name']}/{summary['run']}: {summary['passed']}/{summary['total']}")
    print()
    print("Summary:")
    for s in summaries:
        rate = s["passed"] / s["total"] if s["total"] else 0
        print(f"  {s['eval_name']:<45} {s['run']:<14} {s['passed']:>2}/{s['total']:<2} ({rate:.0%})")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python grade.py <iteration-dir>")
        sys.exit(1)
    main(sys.argv[1])
