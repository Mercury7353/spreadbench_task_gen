# SpreadsheetEval final result

## Acceptance

- Dataset: 10 Harbor tasks - five Financial Modeling, five Debugging.
- Mother workbooks: five existing human-authored financial models, 2-22 sheets
  and 321-3,865 genuine formulas, under Apache-2.0 or MIT licenses.
- Final Harbor Oracle: 10/10, mean **1.000**, zero exceptions.
- DeepSeek `deepseek-chat` + Terminus-2: 0/10, mean **0.000**, zero exceptions.
- Required difficulty: Overall Pass@1 <= 0.200; achieved **0.000**.
- DeepSeek runtime: 64m55s; 16,684,511 input tokens, 16,148,224 cached
  tokens, 222,177 output tokens, $0.182505 recorded cost.
- The final verifier replayed all ten saved candidates and reproduced 0/10.

## Original-evaluation evidence

The weakness taxonomy precedes construction. The completed original
SpreadsheetBench V2 Template split contains 97/97 trajectories and official
regression/modification scores:

- 7/97 passes (0.0722);
- 63 zero-target-coverage cases, including 12 missing deliverables;
- 27 incomplete-target-coverage cases;
- 27 over-editing cases;
- 15 context-bloat, 11 numerical-looping, 8 tool-protocol, 5
  budget-exhaustion, and 3 exactness-near-miss cases.

All 97 cases are enumerated in `original_template_97_cases.{md,json}`. Each
constructed task manifest references two source case IDs and embeds their exact
weakness labels; automated provenance tests reject any mismatch.

## Constructed-case outcomes

| Task | Required | Missing | Extra | Reward |
|---|---:|---:|---:|---:|
| `debugging-01-manufacturing-plan` | 26 | 0 | 14 | 0 |
| `debugging-02-commercial-real-estate` | 24 | 0 | 10 | 0 |
| `debugging-03-coal-india` | 24 | 1 | 0 | 0 |
| `debugging-04-financial-projection` | 32 | 7 | 49 | 0 |
| `debugging-05-project-finance` | 32 | 7 | 0 | 0 |
| `financial-01-manufacturing-plan` | 140 | 22 | 2 | 0 |
| `financial-02-commercial-real-estate` | 60 | 0 | 1 | 0 |
| `financial-03-coal-india` | 130 | 53 | 0 | 0 |
| `financial-04-financial-projection` | 140 | 3 | 22 | 0 |
| `financial-05-project-finance` | 140 | 12 | 0 | 0 |

The strongest near-miss repaired all 60 requested formulas and made one extra
edit. The strict modified-cell-set rule correctly assigned reward 0.

## Validation

- The pre- and post-provenance-regeneration semantic digests of all 40 dataset
  workbook copies are identical.
- Eight project tests pass: dataset/category shape, Harbor layout, exact mutation
  set, Oracle payload identity, source-case provenance, deterministic operators,
  numeric normalization, and workbook-structure rejection.
- Both unchanged input and a correct workbook with one extra edit score 0.
- The final verifier additionally rejects sheet/order/state, dimensions, merged
  ranges, or freeze-pane changes.
- Complete trajectories, terminal recordings, candidates, trial results, and
  verifier outputs are committed under `evaluation_artifacts/real-deepseek-full`.

See `model-trajectory-findings.md` for manual case-by-case behavior analysis and
`real-deepseek-full-case-analysis.{md,json}` for full cell-level verifier evidence.
