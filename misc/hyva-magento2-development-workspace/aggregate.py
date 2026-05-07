#!/usr/bin/env python3
"""Aggregate grading + timing across runs into benchmark.json + benchmark.md."""
import json
import statistics
import sys
from pathlib import Path


def collect(iteration_dir: Path):
    rows = []
    for eval_dir in sorted(iteration_dir.iterdir()):
        if not eval_dir.is_dir() or not eval_dir.name.startswith("eval-"):
            continue
        for run_subdir in ("with_skill", "without_skill"):
            run_path = eval_dir / run_subdir
            grading = run_path / "grading.json"
            timing = run_path / "timing.json"
            if not grading.exists():
                continue
            g = json.loads(grading.read_text(encoding="utf-8"))
            t = {}
            if timing.exists():
                t = json.loads(timing.read_text(encoding="utf-8"))
            passed = sum(1 for e in g["expectations"] if e["passed"])
            total = len(g["expectations"])
            rows.append({
                "eval_name": eval_dir.name.replace("eval-", "", 1).split("-", 1)[-1] if "-" in eval_dir.name[5:] else eval_dir.name,
                "eval_dir": eval_dir.name,
                "run": run_subdir,
                "passed": passed,
                "total": total,
                "pass_rate": passed / total if total else 0,
                "tokens": t.get("total_tokens"),
                "duration_s": t.get("total_duration_seconds"),
                "expectations": g["expectations"],
            })
    return rows


def fmt_summary(rows, run_filter):
    filtered = [r for r in rows if r["run"] == run_filter]
    if not filtered:
        return None
    pass_rates = [r["pass_rate"] for r in filtered]
    tokens = [r["tokens"] for r in filtered if r["tokens"] is not None]
    durations = [r["duration_s"] for r in filtered if r["duration_s"] is not None]
    return {
        "configuration": run_filter,
        "n_evals": len(filtered),
        "mean_pass_rate": statistics.mean(pass_rates) if pass_rates else 0,
        "stddev_pass_rate": statistics.stdev(pass_rates) if len(pass_rates) > 1 else 0,
        "mean_tokens": statistics.mean(tokens) if tokens else 0,
        "stddev_tokens": statistics.stdev(tokens) if len(tokens) > 1 else 0,
        "mean_duration_s": statistics.mean(durations) if durations else 0,
        "stddev_duration_s": statistics.stdev(durations) if len(durations) > 1 else 0,
    }


def main(iteration_dir_str: str, skill_name: str):
    iteration_dir = Path(iteration_dir_str)
    rows = collect(iteration_dir)

    benchmark = {
        "skill_name": skill_name,
        "iteration": iteration_dir.name,
        "configurations": [],
        "per_eval": [],
    }

    # Order: with_skill BEFORE without_skill (per skill-creator convention)
    for run_filter in ("with_skill", "without_skill"):
        s = fmt_summary(rows, run_filter)
        if s:
            benchmark["configurations"].append(s)

    # Per-eval: pair with_skill/without_skill side-by-side
    eval_dirs = sorted({r["eval_dir"] for r in rows})
    for ed in eval_dirs:
        with_run = next((r for r in rows if r["eval_dir"] == ed and r["run"] == "with_skill"), None)
        without_run = next((r for r in rows if r["eval_dir"] == ed and r["run"] == "without_skill"), None)
        benchmark["per_eval"].append({
            "eval_dir": ed,
            "with_skill": {
                "passed": with_run["passed"] if with_run else None,
                "total": with_run["total"] if with_run else None,
                "pass_rate": with_run["pass_rate"] if with_run else None,
                "tokens": with_run["tokens"] if with_run else None,
                "duration_s": with_run["duration_s"] if with_run else None,
            } if with_run else None,
            "without_skill": {
                "passed": without_run["passed"] if without_run else None,
                "total": without_run["total"] if without_run else None,
                "pass_rate": without_run["pass_rate"] if without_run else None,
                "tokens": without_run["tokens"] if without_run else None,
                "duration_s": without_run["duration_s"] if without_run else None,
            } if without_run else None,
        })

    out_json = iteration_dir / "benchmark.json"
    out_json.write_text(json.dumps(benchmark, indent=2), encoding="utf-8")

    # Markdown
    md = []
    md.append(f"# {skill_name} — {iteration_dir.name}\n")
    md.append("## Aggregate\n")
    md.append("| Configuration | n | Pass rate (mean ± sd) | Tokens (mean ± sd) | Duration s (mean ± sd) |")
    md.append("|---|---|---|---|---|")
    for c in benchmark["configurations"]:
        md.append(
            f"| **{c['configuration']}** | {c['n_evals']} | "
            f"{c['mean_pass_rate']:.0%} ± {c['stddev_pass_rate']:.0%} | "
            f"{c['mean_tokens']:.0f} ± {c['stddev_tokens']:.0f} | "
            f"{c['mean_duration_s']:.1f} ± {c['stddev_duration_s']:.1f} |"
        )
    md.append("\n## Per eval\n")
    md.append("| Eval | with_skill | without_skill | Δ pass rate |")
    md.append("|---|---|---|---|")
    for pe in benchmark["per_eval"]:
        ws = pe["with_skill"]
        wos = pe["without_skill"]
        ws_str = f"{ws['passed']}/{ws['total']} ({ws['pass_rate']:.0%})" if ws else "n/a"
        wos_str = f"{wos['passed']}/{wos['total']} ({wos['pass_rate']:.0%})" if wos else "n/a"
        delta = ""
        if ws and wos:
            d = ws['pass_rate'] - wos['pass_rate']
            delta = f"{'+' if d >= 0 else ''}{d:.0%}"
        md.append(f"| {pe['eval_dir']} | {ws_str} | {wos_str} | {delta} |")
    out_md = iteration_dir / "benchmark.md"
    out_md.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(f"Wrote {out_json}")
    print(f"Wrote {out_md}")
    print()
    print("\n".join(md))


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python aggregate.py <iteration-dir> <skill-name>")
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
