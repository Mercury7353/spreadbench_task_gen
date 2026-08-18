# SpreadsheetEval: weakness-grounded construction

This deliverable constructs Harbor spreadsheet tasks from **existing,
human-authored financial Excel models**. Programmatic code does not invent the
base models; it only downloads licensed workbooks, converts legacy `.xls`
files, applies auditable mutations, and packages strict OJ tasks.

## 1. Original evaluation evidence first

The frozen analysis set is the completed SpreadsheetBench V2 Template split:
97/97 DeepSeek trajectories plus candidate workbooks and the official
regression/modification evaluator.

| Metric | Result |
|---|---:|
| Overall Pass@1 | 7/97 = 0.0722 |
| Missing outputs | 12 |
| Submitted cases with zero target coverage | 51 |
| Partial target coverage | 27 |
| Cases that damaged preserved cells | 27 |
| Context-bloat cases (≥500k sent tokens) | 15 |
| Numerical-looping cases | 11 |
| Tool-format exits | 8 |
| Cost-limit exits | 5 |
| Exactness near-misses | 3 |

Every case is documented in
`reports/original_template_97_cases.{md,json}` with instruction paths, official
scores, first evaluator error, exit status, API/token counts, weakness tags,
and the original trajectory path. Weaknesses are therefore derived from the
original benchmark, not inferred from the constructed tasks.

## 2. Real workbook sources

The five accepted models contain 2–22 sheets and 321–3,865 formulas:

- five-year manufacturing financial plan;
- commercial real-estate valuation model;
- Coal India financial model and valuation;
- 22-sheet financial projection model;
- Packt project-finance model.

Four are from the Apache-2.0 `IanMadlenya/finance-excel` collection; one is the
MIT-licensed Packt project-finance workbook. License files, exact URLs, used
files, conversion method, and rejected-source reasons are preserved in
`third_party/real_workbooks/SOURCES.md`.

```bash
bash scripts/fetch_real_workbooks.sh
python scripts/generate_real_spreadsheet_eval.py
```

## 3. Case → weakness → operator → task

Each generated task manifest embeds `source_original_cases`, `weaknesses`, and
the complete cell-level mutation log.

| Original failure | Operator recipe | Constructed pressure |
|---|---|---|
| zero/partial target coverage | `blank_formula` across formula-rich sheets | coordinated formula restoration |
| regression damage / over-editing | sparse sign, offset, reference-drift mutations among protected formulas | exact repair without rewriting correct regions |
| exactness near-miss | exact changed-cell-set gate | one missed or extra cell fails |
| context bloat | retain the complete real workbook | navigate 2–22 authentic sheets |
| numerical looping | preserve genuine valuation/debt/forecast formulas | reason inside the workbook rather than external scalar loops |

Final dataset:

- `financial-01..05`: 60–140 missing formulas, derived from five real models;
- `debugging-01..05`: 24–32 heterogeneous formula defects;
- no charts/visualization or subjective evaluation;
- five Financial Modeling and five Debugging tasks.

Task-level grounding is explicit rather than a dataset-wide claim:

| Constructed task | Original V2 evidence cases |
|---|---|
| `financial-01-manufacturing-plan` | `04_04`, `06_01` |
| `financial-02-commercial-real-estate` | `06_02`, `06_03` |
| `financial-03-coal-india` | `06_04`, `06_05` |
| `financial-04-financial-projection` | `07_01`, `07_02` |
| `financial-05-project-finance` | `11_01`, `11_02` |
| `debugging-01-manufacturing-plan` | `01_02`, `01_04` |
| `debugging-02-commercial-real-estate` | `02_02`, `02_05` |
| `debugging-03-coal-india` | `03_01`, `03_03` |
| `debugging-04-financial-projection` | `05_01`, `05_02` |
| `debugging-05-project-finance` | `06_06`, `06_08` |

`tests/test_generation.py` checks every embedded case ID and weakness label
against the frozen 97-case report. It also verifies that each source has an
approved license and that exactly five distinct real workbooks are each used
once per category.

## 4. Strict OJ verifier

The verifier:

1. rejects a missing `/workspace/output.xlsx`;
2. requires the workbook sheet/state/merge/freeze/dimension structure to match;
3. requires the raw modified-cell set to equal the manifest exactly;
4. recalculates candidate and reference with LibreOffice;
5. normalizes dates and compares numeric values to two decimals;
6. writes only reward 0 or 1.

Both an unchanged input and a correct answer with one extra edit score 0.

## 5. Validation and evaluation

```bash
harbor run -p SpreadsheetEval -a oracle --n-concurrent 1
bash scripts/run_construction_eval.sh real-deepseek-full
bash scripts/monitor_construction_eval.sh real-deepseek-full 60
python scripts/analyze_harbor_results.py real-deepseek-full
```

| Run | Result |
|---|---:|
| Harbor Oracle | 10/10, mean 1.000, 0 exceptions |
| DeepSeek `deepseek-chat` + Terminus-2 | 0/10, mean 0.000, 0 exceptions |

The DeepSeek run took 64m55s and recorded 16,684,511 input tokens,
16,148,224 cached tokens, 222,177 output tokens, and $0.182505 cost. The
requested endpoint was `deepseek-chat`; ATIF steps report the provider-routed
model name `deepseek-v4-flash`.

Harbor preserves per-trial ATIF trajectory JSON, terminal recording, candidate
workbook, verifier stdout, token/cost statistics, and reward under `jobs/`.
The ten complete final trials are also exported to
`evaluation_artifacts/real-deepseek-full/` and committed. Transient jobs and
API keys remain gitignored.
