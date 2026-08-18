# DeepSeek trajectory findings: manual case review

All ten ATIF trajectories were read together with the candidate workbook and
strict verifier delta. The requested endpoint was `deepseek-chat`; the model
name returned inside every ATIF step was `deepseek-v4-flash`.

## Aggregate

- Overall Pass@1: **0/10 = 0.000**; zero infrastructure exceptions.
- Seven cases left at least one required target unchanged.
- Six cases changed at least one correct cell.
- Three cases had both missing and extra edits.
- Two cases were one-cell exactness near-misses: `debugging-03` missed one cell;
  `financial-02` repaired all 60 targets but added one edit.
- Three trajectories used at least 50 steps; the largest used 68 steps and 101
  tool calls.
- A repeated validation error was treating “LibreOffice recalculates without
  formula errors” or “outputs look plausible” as proof of exact task coverage.

## Case-by-case observations

| Task | Target / missing / extra | Trajectory observation | Triggered bad pattern |
|---|---:|---|---|
| `debugging-01-manufacturing-plan` | 26 / 0 / 14 | The audit found every injected defect, then generalized balance-sheet and model-input patterns to 14 correct cells. Recalculated cash ties and a zero ending loan balance increased confidence despite the changed-set error. | Business-plausibility validation cannot control over-editing. |
| `debugging-02-commercial-real-estate` | 24 / 0 / 10 | The model reconstructed all injected formulas, but also replaced ten legitimate debt-service values/formulas because a standard CRE convention looked more plausible. | Prior business conventions override local workbook ground truth. |
| `debugging-03-coal-india` | 24 / 1 / 0 | After 49 steps and 60 tool calls, wrapper-pattern scans and a clean LibreOffice recalculation still missed `P&L!K59`. | Sparse global audit has a long-tail recall problem. |
| `debugging-04-financial-projection` | 32 / 7 / 49 | The model inferred that two full sales-forecast rows were wrong and rewrote 48 monthly cells, while seven defects in three income-statement variants remained. | Local pattern completion produces a severe precision/recall tradeoff. |
| `debugging-05-project-finance` | 32 / 7 / 0 | It removed obvious `1+(...)`, sign, and reference anomalies and verified that no error values remained, but missed defects across Construction, P&L, CFS, and Ratios. | Error-string scans do not cover sparse semantic faults across sheets. |
| `financial-01-manufacturing-plan` | 140 / 22 / 2 | Blank-gap heuristics restored most blocks and the loan schedule recalculated, but 22 scattered targets remained and two cash-flow cells were added. | Dense block completion misses isolated edge cells and can spill past the target set. |
| `financial-02-commercial-real-estate` | 60 / 0 / 1 | This was the closest run: every required formula was restored, but pattern inference also filled `Model!D72`. | Exactness near-miss: one reasonable extra edit makes the whole workbook fail. |
| `financial-03-coal-india` | 130 / 53 / 0 | The trajectory explicitly avoided uncertain Valuation sensitivity cells and later discovered that one Assumptions pass had overwritten another pass. It submitted after restoring only the easier statements. | Risk avoidance improves precision at the cost of catastrophic target coverage. |
| `financial-04-financial-projection` | 140 / 3 / 22 | Across 22 sheets, broad styled-blank heuristics generated extra year-end and amortization formulas. After 68 steps, three real holes still remained. | Context bloat plus heuristic overgeneralization causes both late execution and over-editing. |
| `financial-05-project-finance` | 140 / 12 / 0 | The model filled internal holes and stopped after clean IRR/error checks; paired and edge formulas in Operation, CFS, P&L, Ratios, and Balance Sheet were still blank. | Internal-gap detection systematically misses edge and sparse targets. |

The complete cell lists, token/cost statistics, and embedded final agent messages
are in `real-deepseek-full-case-analysis.{md,json}`. Unabridged trajectories,
terminal recordings, candidate workbooks, and verifier evidence are under
`evaluation_artifacts/real-deepseek-full/`.
