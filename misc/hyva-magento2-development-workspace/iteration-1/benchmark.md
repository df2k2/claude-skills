# hyva-magento2-development — iteration-1

## Aggregate

| Configuration | n | Pass rate (mean ± sd) | Tokens (mean ± sd) | Duration s (mean ± sd) |
|---|---|---|---|---|
| **with_skill** | 6 | 88% ± 6% | 68504 ± 9620 | 137.2 ± 34.2 |
| **without_skill** | 6 | 84% ± 13% | 51284 ± 3758 | 133.4 ± 46.3 |

## Per eval

| Eval | with_skill | without_skill | Δ pass rate |
|---|---|---|---|
| eval-1-alpine-modal-with-section-data | 8/9 (89%) | 7/9 (78%) | +11% |
| eval-2-csp-payment-toggle | 6/7 (86%) | 6/7 (86%) | +0% |
| eval-3-tailwind-v4-dynamic-class | 6/6 (100%) | 6/6 (100%) | +0% |
| eval-4-compat-module-luma-extension | 6/7 (86%) | 5/7 (71%) | +14% |
| eval-5-minicart-update-after-custom-add | 5/6 (83%) | 6/6 (100%) | -17% |
| eval-6-view-model-for-store-info | 6/7 (86%) | 5/7 (71%) | +14% |
