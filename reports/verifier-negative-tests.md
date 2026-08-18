# Strict verifier negative tests

Final verifier, task `debugging-01-manufacturing-plan`:

| Candidate | Expected failure | Observed reason | Reward |
|---|---|---|---:|
| Unchanged `input.xlsx` | 26 missing edits | `modified_set_mismatch`: 26 missing, 0 extra | 0 |
| Correct `reference.xlsx` plus edit to `Model Inputs!A1` | one extra edit | `modified_set_mismatch`: 0 missing, 1 extra | 0 |

The second test demonstrates that recalculated correctness is insufficient: an
otherwise correct workbook fails if one correct cell is changed.
