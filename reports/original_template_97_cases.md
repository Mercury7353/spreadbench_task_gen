# Original SpreadsheetBench V2 Template: all 97 cases

This report uses only original task instructions, trajectories, candidate outputs, and the official evaluator.

## Aggregate

- `zero-target-coverage`: 63 cases
- `incomplete-target-coverage`: 27 cases
- `over-editing`: 27 cases
- `context-bloat`: 15 cases
- `no-deliverable`: 12 cases
- `numerical-looping`: 11 cases
- `tool-protocol`: 8 cases
- `budget-exhaustion`: 5 cases
- `exactness-near-miss`: 3 cases

## Case-by-case evidence

### `01_01`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_cost` / 51 / 732,806
- Weaknesses: budget-exhaustion, context-bloat, no-deliverable, numerical-looping, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/01_01/01_01.traj`

### `01_02`

- Score: pass=0; regression=0.9956; modification=0.7885
- Exit/API/tokens: `submitted` / 33 / 413,588
- Weaknesses: incomplete-target-coverage, numerical-looping, over-editing
- Evaluator evidence: Regression error at OID_Bond!C24: answer=0, output=630
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/01_02/01_02.traj`

### `01_03`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_format` / 13 / 86,612
- Weaknesses: no-deliverable, numerical-looping, tool-protocol, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/01_03/01_03.traj`

### `01_04`

- Score: pass=0; regression=0.9625; modification=0.9158
- Exit/API/tokens: `submitted` / 31 / 649,909
- Weaknesses: context-bloat, incomplete-target-coverage, numerical-looping, over-editing
- Evaluator evidence: Regression error at OID_Bond!C29: answer=None, output=9420
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/01_04/01_04.traj`

### `01_05`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_format` / 17 / 142,950
- Weaknesses: no-deliverable, numerical-looping, tool-protocol, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/01_05/01_05.traj`

### `01_06`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_format` / 26 / 461,512
- Weaknesses: no-deliverable, numerical-looping, tool-protocol, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/01_06/01_06.traj`

### `01_07`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_cost` / 51 / 556,069
- Weaknesses: budget-exhaustion, context-bloat, no-deliverable, numerical-looping, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/01_07/01_07.traj`

### `01_08`

- Score: pass=0; regression=0.9835; modification=0.4561
- Exit/API/tokens: `submitted` / 41 / 864,086
- Weaknesses: context-bloat, incomplete-target-coverage, numerical-looping, over-editing
- Evaluator evidence: Regression error at BondAccounting!C32: answer=0, output=-137.5
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/01_08/01_08.traj`

### `01_09`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_cost` / 51 / 1,116,198
- Weaknesses: budget-exhaustion, context-bloat, no-deliverable, numerical-looping, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/01_09/01_09.traj`

### `02_01`

- Score: pass=0; regression=1.0000; modification=0.8750
- Exit/API/tokens: `submitted` / 6 / 19,903
- Weaknesses: incomplete-target-coverage
- Evaluator evidence: Modification error at Revenue_Analysis!D13: answer=0.31752, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/02_01/02_01.traj`

### `02_02`

- Score: pass=0; regression=0.9459; modification=0.5068
- Exit/API/tokens: `submitted` / 18 / 213,875
- Weaknesses: incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at DebtWaterfall!B16: answer=0, output=18
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/02_02/02_02.traj`

### `02_03`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_format` / 6 / 17,069
- Weaknesses: no-deliverable, tool-protocol, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/02_03/02_03.traj`

### `02_04`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_format` / 6 / 25,780
- Weaknesses: no-deliverable, tool-protocol, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/02_04/02_04.traj`

### `02_05`

- Score: pass=0; regression=0.8483; modification=0.0750
- Exit/API/tokens: `submitted` / 9 / 55,273
- Weaknesses: incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at DebtWaterfall!B6: answer=Beginning cash, output=450
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/02_05/02_05.traj`

### `02_06`

- Score: pass=0; regression=0.9937; modification=0.6429
- Exit/API/tokens: `submitted` / 42 / 1,325,084
- Weaknesses: context-bloat, incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at DebtWaterfall!B25: answer=0, output=-22.6
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/02_06/02_06.traj`

### `03_01`

- Score: pass=0; regression=0.9777; modification=0.5116
- Exit/API/tokens: `submitted` / 13 / 151,573
- Weaknesses: incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at M&A_Consolidation!C14: answer=None, output=3400
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/03_01/03_01.traj`

### `03_02`

- Score: pass=0; regression=0.9412; modification=0.8636
- Exit/API/tokens: `submitted` / 28 / 676,783
- Weaknesses: context-bloat, incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at M&A_Consolidation!C14: answer=None, output=3500
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/03_02/03_02.traj`

### `03_03`

- Score: pass=0; regression=0.9801; modification=0.9787
- Exit/API/tokens: `submitted` / 8 / 45,477
- Weaknesses: incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at Consolidation!C21: answer=0, output=2200
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/03_03/03_03.traj`

### `03_04`

- Score: pass=1; regression=1.0000; modification=1.0000
- Exit/API/tokens: `submitted` / 8 / 35,054
- Weaknesses: none (passed)
- Evaluator evidence: PASS
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/03_04/03_04.traj`

### `04_03`

- Score: pass=0; regression=0.9833; modification=0.0000
- Exit/API/tokens: `submitted` / 16 / 188,740
- Weaknesses: over-editing, zero-target-coverage
- Evaluator evidence: Regression error at FCF_Calculation!C12: answer=None, output=0.24
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/04_03/04_03.traj`

### `04_04`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 13 / 105,775
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at FCF_Calc!D13: answer=82, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/04_04/04_04.traj`

### `05_01`

- Score: pass=0; regression=0.9942; modification=0.9649
- Exit/API/tokens: `submitted` / 6 / 25,007
- Weaknesses: exactness-near-miss, incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at DeferredTax!C23: answer=None, output=100
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/05_01/05_01.traj`

### `05_02`

- Score: pass=0; regression=1.0000; modification=0.9545
- Exit/API/tokens: `submitted` / 13 / 78,109
- Weaknesses: exactness-near-miss, incomplete-target-coverage
- Evaluator evidence: Modification error at DeferredTax!D32: answer=-21, output=21
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/05_02/05_02.traj`

### `06_01`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 13 / 100,395
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at ProductRevenue!D16: answer=66240, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_01/06_01.traj`

### `06_02`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 15 / 80,292
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at WC_Forecast!C24: answer=1800, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_02/06_02.traj`

### `06_03`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 8 / 41,906
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at iPhone_Revenue_Build!C17: answer=49.5, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_03/06_03.traj`

### `06_04`

- Score: pass=0; regression=1.0000; modification=0.6923
- Exit/API/tokens: `submitted` / 11 / 57,775
- Weaknesses: incomplete-target-coverage
- Evaluator evidence: Modification error at DrugRevenue!D11: answer=891, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_04/06_04.traj`

### `06_05`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 7 / 17,278
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at WorkingCapital!C11: answer=14697, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_05/06_05.traj`

### `06_06`

- Score: pass=0; regression=0.9135; modification=0.9836
- Exit/API/tokens: `submitted` / 16 / 260,662
- Weaknesses: incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at Revenue_Forecast!G9: answer=None, output=0.3
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_06/06_06.traj`

### `06_07`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_cost` / 51 / 809,308
- Weaknesses: budget-exhaustion, context-bloat, no-deliverable, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_07/06_07.traj`

### `06_08`

- Score: pass=0; regression=0.8976; modification=0.0000
- Exit/API/tokens: `submitted` / 32 / 571,062
- Weaknesses: context-bloat, over-editing, zero-target-coverage
- Evaluator evidence: Regression error at WorkingCapital_Forecast!B17: answer=FN: Cash flow sign convention for WC changes, output=Accounts Payable
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_08/06_08.traj`

### `06_09`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 10 / 58,951
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at OpEx_Forecast!C11: answer=0.175038520801233, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_09/06_09.traj`

### `06_11`

- Score: pass=0; regression=1.0000; modification=0.5417
- Exit/API/tokens: `submitted` / 17 / 178,435
- Weaknesses: incomplete-target-coverage
- Evaluator evidence: Modification error at WC_Forecast!F13: answer=3416.6475, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_11/06_11.traj`

### `06_12`

- Score: pass=0; regression=1.0000; modification=0.7333
- Exit/API/tokens: `submitted` / 6 / 39,250
- Weaknesses: incomplete-target-coverage
- Evaluator evidence: Modification error at CashFlow_Build!I12: answer=-570, output=-345
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_12/06_12.traj`

### `06_13`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 21 / 265,557
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at CashFlowBuild!B26: answer=CASH FLOW STATEMENT (To Complete), output=• Asset increases (AR, Inventory) reduce cash (subtract from cash flow)
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_13/06_13.traj`

### `06_14`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 13 / 121,034
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at SegmentRevenue!C11: answer=606.25, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_14/06_14.traj`

### `06_15`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 13 / 61,090
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at WorkingCapital!C17: answer=2893.33333333333, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_15/06_15.traj`

### `06_16`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 11 / 67,930
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at QuarterlyPL_Forecast!C13: answer=0.59, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_16/06_16.traj`

### `06_17`

- Score: pass=0; regression=1.0000; modification=0.0161
- Exit/API/tokens: `submitted` / 15 / 104,636
- Weaknesses: incomplete-target-coverage
- Evaluator evidence: Modification error at OpEx_Forecast!C25: answer=0.145, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_17/06_17.traj`

### `06_18`

- Score: pass=0; regression=0.9362; modification=0.0000
- Exit/API/tokens: `submitted` / 8 / 21,706
- Weaknesses: over-editing, zero-target-coverage
- Evaluator evidence: Regression error at WorkingCapital_Forecast!B16: answer=4861.11111111111, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_18/06_18.traj`

### `06_19`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 31 / 726,095
- Weaknesses: context-bloat, zero-target-coverage
- Evaluator evidence: Modification error at IncomeStatement!B10: answer=0.0761821366024519, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_19/06_19.traj`

### `06_20`

- Score: pass=0; regression=1.0000; modification=0.5625
- Exit/API/tokens: `submitted` / 24 / 486,213
- Weaknesses: incomplete-target-coverage
- Evaluator evidence: Modification error at RevenueBuild!C46: answer=155.898896061625, output=159.2507223269502
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_20/06_20.traj`

### `06_21`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 12 / 79,454
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at WorkingCapital!E19: answer=560.876712328767, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_21/06_21.traj`

### `06_22`

- Score: pass=1; regression=1.0000; modification=1.0000
- Exit/API/tokens: `submitted` / 37 / 652,741
- Weaknesses: context-bloat
- Evaluator evidence: PASS
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_22/06_22.traj`

### `06_23`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 11 / 59,451
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at WorkingCapital!C37: answer=None, output=Use cash flow convention: ΔAP - ΔAR - ΔInv (sources minus uses)
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_23/06_23.traj`

### `06_24`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 11 / 48,678
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at RevenueBuild!C14: answer=145, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_24/06_24.traj`

### `06_25`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 8 / 32,255
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at RevenueDrivers!B31: answer=Same-Store Sales Growth (ex-Gas), output=Same-Store Sales Growth (ex-Gas) %
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/06_25/06_25.traj`

### `07_01`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 12 / 84,794
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at EquityDRD!C14: answer=1070, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/07_01/07_01.traj`

### `07_02`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_format` / 14 / 99,728
- Weaknesses: no-deliverable, tool-protocol, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/07_02/07_02.traj`

### `07_03`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_format` / 5 / 16,542
- Weaknesses: no-deliverable, tool-protocol, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/07_03/07_03.traj`

### `08_01`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 18 / 221,894
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at DebtSchedule!C7: answer=1370.93573264782, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/08_01/08_01.traj`

### `08_02`

- Score: pass=0; regression=1.0000; modification=0.0735
- Exit/API/tokens: `submitted` / 23 / 512,063
- Weaknesses: context-bloat, incomplete-target-coverage
- Evaluator evidence: Modification error at DebtSchedule!C17: answer=1286.25, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/08_02/08_02.traj`

### `08_03`

- Score: pass=0; regression=0.9925; modification=0.0000
- Exit/API/tokens: `submitted` / 12 / 62,737
- Weaknesses: over-editing, zero-target-coverage
- Evaluator evidence: Regression error at IncomeProjection!C9: answer=-26757.5, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/08_03/08_03.traj`

### `09_01`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 18 / 239,417
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at DebtSchedule!C8: answer=55, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/09_01/09_01.traj`

### `09_02`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 19 / 232,287
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at DebtSchedule!C9: answer=55, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/09_02/09_02.traj`

### `09_03`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 18 / 160,234
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at Sheet!D10: answer=-11.7, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/09_03/09_03.traj`

### `09_04`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 15 / 99,358
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at DebtSchedule!C16: answer=1.8, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/09_04/09_04.traj`

### `10_01`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 11 / 66,845
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at EPS_Accretion!C15: answer=1350, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/10_01/10_01.traj`

### `10_02`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 12 / 79,730
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at EPS_Accretion!C24: answer=0.899682251475261, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/10_02/10_02.traj`

### `11_01`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 19 / 173,870
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at DebtSchedule!E7: answer=1200, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/11_01/11_01.traj`

### `11_02`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 12 / 77,234
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at PPA!D13: answer=-147, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/11_02/11_02.traj`

### `11_03`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 21 / 159,507
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at MergerPremium!C6: answer=1200, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/11_03/11_03.traj`

### `11_04`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 11 / 79,110
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at PPA!C18: answer=-131.6, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/11_04/11_04.traj`

### `12_01`

- Score: pass=0; regression=1.0000; modification=0.9213
- Exit/API/tokens: `submitted` / 12 / 91,298
- Weaknesses: exactness-near-miss, incomplete-target-coverage
- Evaluator evidence: Modification error at NOL_Carryforward!D9: answer=45, output=11.25
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/12_01/12_01.traj`

### `13_01`

- Score: pass=1; regression=1.0000; modification=1.0000
- Exit/API/tokens: `submitted` / 14 / 151,931
- Weaknesses: none (passed)
- Evaluator evidence: PASS
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/13_01/13_01.traj`

### `13_02`

- Score: pass=1; regression=1.0000; modification=1.0000
- Exit/API/tokens: `submitted` / 7 / 54,800
- Weaknesses: none (passed)
- Evaluator evidence: PASS
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/13_02/13_02.traj`

### `13_03`

- Score: pass=0; regression=1.0000; modification=0.8554
- Exit/API/tokens: `submitted` / 20 / 403,386
- Weaknesses: incomplete-target-coverage
- Evaluator evidence: Modification error at FinancialNormalization!D32: answer=17.75, output=28.25
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/13_03/13_03.traj`

### `13_04`

- Score: pass=0; regression=0.9952; modification=0.6761
- Exit/API/tokens: `submitted` / 6 / 25,458
- Weaknesses: incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at Normalize_Adjustments!C20: answer=0, output=0.1054
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/13_04/13_04.traj`

### `13_05`

- Score: pass=0; regression=0.0000; modification=0.0000
- Exit/API/tokens: `exit_format` / 11 / 56,791
- Weaknesses: no-deliverable, tool-protocol, zero-target-coverage
- Evaluator evidence: output file not exist
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/13_05/13_05.traj`

### `13_06`

- Score: pass=0; regression=0.9789; modification=0.0000
- Exit/API/tokens: `submitted` / 20 / 368,915
- Weaknesses: over-editing, zero-target-coverage
- Evaluator evidence: Regression error at FinancialNormalization!D14: answer=210, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/13_06/13_06.traj`

### `13_07`

- Score: pass=0; regression=0.9779; modification=0.6044
- Exit/API/tokens: `submitted` / 24 / 419,122
- Weaknesses: incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at Normalization!I23: answer=None, output=0.09384278002699056
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/13_07/13_07.traj`

### `13_08`

- Score: pass=1; regression=1.0000; modification=1.0000
- Exit/API/tokens: `submitted` / 6 / 25,667
- Weaknesses: none (passed)
- Evaluator evidence: PASS
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/13_08/13_08.traj`

### `14_01`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 16 / 173,762
- Weaknesses: numerical-looping, zero-target-coverage
- Evaluator evidence: Modification error at DCF_Analysis!C32: answer=2489018, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/14_01/14_01.traj`

### `14_02`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 15 / 164,822
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at OpEx_Projection!D20: answer=876200, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/14_02/14_02.traj`

### `14_03`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 10 / 65,121
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at NOI_Projection!C15: answer=-81765, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/14_03/14_03.traj`

### `14_04`

- Score: pass=1; regression=1.0000; modification=1.0000
- Exit/API/tokens: `submitted` / 21 / 247,560
- Weaknesses: none (passed)
- Evaluator evidence: PASS
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/14_04/14_04.traj`

### `14_05`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 21 / 240,284
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at NOI_Projection!C35: answer=4850000, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/14_05/14_05.traj`

### `14_06`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 16 / 123,017
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at OpEx_Projection!C28: answer=1823000, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/14_06/14_06.traj`

### `14_07`

- Score: pass=0; regression=0.9875; modification=0.0000
- Exit/API/tokens: `submitted` / 11 / 79,157
- Weaknesses: over-editing, zero-target-coverage
- Evaluator evidence: Regression error at RentRoll!B4: answer=2026-05-27 00:00:00, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/14_07/14_07.traj`

### `14_08`

- Score: pass=1; regression=1.0000; modification=1.0000
- Exit/API/tokens: `submitted` / 25 / 371,545
- Weaknesses: none (passed)
- Evaluator evidence: PASS
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/14_08/14_08.traj`

### `14_09`

- Score: pass=0; regression=0.7835; modification=0.0000
- Exit/API/tokens: `submitted` / 35 / 674,707
- Weaknesses: context-bloat, over-editing, zero-target-coverage
- Evaluator evidence: Regression error at Revenue_Projection!B15: answer=None, output=Year 3 Concessions (% of Market Rent)
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/14_09/14_09.traj`

### `15_01`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 22 / 213,984
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at DebtAnalysis!C27: answer=84000000, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/15_01/15_01.traj`

### `15_02`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 22 / 309,677
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at LoanSizing!B11: answer=None, output=NOI Growth Rate (Annual)
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/15_02/15_02.traj`

### `15_03`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 12 / 80,223
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at LoanSizing!C30: answer=5765000, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/15_03/15_03.traj`

### `15_04`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 15 / 115,139
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at LoanSizing!C26: answer=319574.470171649, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/15_04/15_04.traj`

### `16_01`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 14 / 127,693
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at DirectCap!C13: answer=3.25, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_01/16_01.traj`

### `16_02`

- Score: pass=0; regression=0.9956; modification=0.0000
- Exit/API/tokens: `submitted` / 36 / 555,381
- Weaknesses: context-bloat, over-editing, zero-target-coverage
- Evaluator evidence: Regression error at RentRoll!B4: answer=2026-05-27 00:00:00, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_02/16_02.traj`

### `16_03`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 10 / 47,747
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at RentRoll!C13: answer=320, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_03/16_03.traj`

### `16_04`

- Score: pass=0; regression=1.0000; modification=0.0000
- Exit/API/tokens: `submitted` / 18 / 144,650
- Weaknesses: zero-target-coverage
- Evaluator evidence: Modification error at RentRoll!C13: answer=425, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_04/16_04.traj`

### `16_05`

- Score: pass=0; regression=0.9455; modification=0.0000
- Exit/API/tokens: `submitted` / 20 / 228,166
- Weaknesses: over-editing, zero-target-coverage
- Evaluator evidence: Modification error at DirectCap!H11: answer=2.95635080645161, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_05/16_05.traj`

### `16_06`

- Score: pass=0; regression=1.0000; modification=0.4133
- Exit/API/tokens: `exit_cost` / 51 / 1,341,670
- Weaknesses: budget-exhaustion, context-bloat, incomplete-target-coverage
- Evaluator evidence: Modification error at RentRoll!F13: answer=853.60824742268, output=2519.84536082474
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_06/16_06.traj`

### `16_07`

- Score: pass=0; regression=0.9764; modification=0.0661
- Exit/API/tokens: `submitted` / 30 / 380,681
- Weaknesses: incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at RentRoll!C10: answer=300, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_07/16_07.traj`

### `16_08`

- Score: pass=0; regression=1.0000; modification=0.1270
- Exit/API/tokens: `submitted` / 14 / 89,050
- Weaknesses: incomplete-target-coverage
- Evaluator evidence: Modification error at NOI_Analysis!C8: answer=252510, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_08/16_08.traj`

### `16_09`

- Score: pass=0; regression=0.9698; modification=0.0000
- Exit/API/tokens: `submitted` / 27 / 402,871
- Weaknesses: over-editing, zero-target-coverage
- Evaluator evidence: Modification error at Valuation!H10: answer=3.21928460342146, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_09/16_09.traj`

### `16_10`

- Score: pass=0; regression=0.9467; modification=0.3019
- Exit/API/tokens: `submitted` / 19 / 176,178
- Weaknesses: incomplete-target-coverage, over-editing
- Evaluator evidence: Regression error at DCF!C14: answer=2727000, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_10/16_10.traj`

### `16_11`

- Score: pass=0; regression=0.9377; modification=0.0000
- Exit/API/tokens: `submitted` / 16 / 110,780
- Weaknesses: over-editing, zero-target-coverage
- Evaluator evidence: Regression error at RentRoll!C11: answer=320, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_11/16_11.traj`

### `16_12`

- Score: pass=0; regression=0.9368; modification=0.0000
- Exit/API/tokens: `submitted` / 28 / 252,212
- Weaknesses: numerical-looping, over-editing, zero-target-coverage
- Evaluator evidence: Regression error at RentRoll!C14: answer=280, output=None
- Trajectory: `trajectories/deepseek-chat/full-20260816T032000Z/Template/16_12/16_12.traj`
