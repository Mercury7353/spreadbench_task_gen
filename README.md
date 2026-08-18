# SpreadsheetEval: real-workbook, weakness-grounded Harbor benchmark

This submission contains ten strict OJ spreadsheet-agent tasks: five Financial
Modeling and five Debugging. Every task starts from an existing, human-authored
financial workbook. Code does **not** fabricate base Excel models; it downloads
pinned, permissively licensed sources, normalizes legacy files, and applies
deterministic, cell-audited mutations derived from original SpreadsheetBench V2
failure trajectories.

## Result at a glance

| Evaluation | Tasks | Pass@1 | Exceptions |
|---|---:|---:|---:|
| Harbor Oracle | 10 | **1.000** | 0 |
| DeepSeek `deepseek-chat` + Terminus-2 | 10 | **0.000** | 0 |

The required difficulty threshold is Overall Pass@1 <= 0.200; the measured
result is 0/10. The requested endpoint was `deepseek-chat`; each saved ATIF
model step reports the routed model name `deepseek-v4-flash`. The run completed
without infrastructure exceptions or retries.

## Evidence chain

The construction order is deliberate:

1. Evaluate the original SpreadsheetBench V2 cases.
2. Read every completed Template trajectory and join it to official regression
   and modification scores.
3. Extract observed weaknesses such as zero/partial target coverage,
   over-editing, exactness near-misses, context bloat, numerical looping, and
   missing deliverables.
4. Select five complex, licensed Excel models written by humans.
5. Apply only weakness-targeted mutations to their genuine formula graphs.
6. Require exact modified-cell sets and recalculated values in Harbor.
7. Run Oracle and DeepSeek; retain complete per-trial evidence.

The frozen 97-case source analysis is in
[`reports/original_template_97_cases.md`](reports/original_template_97_cases.md),
with a machine-readable companion JSON containing the score, exit status,
token usage, first evaluator error, weakness labels, and trajectory path for
every case. Task manifests embed the exact source case IDs and weakness labels;
the test suite rejects stale or ungrounded provenance.

The accompanying Chinese Swiss-style HTML briefing is
[`reports/spreadsheetbench-v2-overview.html`](reports/spreadsheetbench-v2-overview.html).
Manual review of every constructed trajectory is in
[`reports/model-trajectory-findings.md`](reports/model-trajectory-findings.md).

## Dataset

| Human-authored mother workbook | Sheets | Formulas | Financial edits | Debugging edits |
|---|---:|---:|---:|---:|
| Five-year manufacturing plan | 5 | 1,875 | 140 | 26 |
| Commercial real-estate valuation | 2 | 321 | 60 | 24 |
| Coal India financial model | 11 | 1,562 | 130 | 24 |
| Financial projection model | 22 | 3,865 | 140 | 32 |
| Packt project-finance model | 10 | 2,973 | 140 | 32 |

Four workbooks are Apache-2.0 files from `IanMadlenya/finance-excel`; the Packt
workbook is MIT licensed. Repositories are pinned to commits. Exact download
URLs, converted-file SHA-256 hashes, license copies, and rejected-workbook audit
reasons are in
[`third_party/real_workbooks/SOURCES.md`](third_party/real_workbooks/SOURCES.md).

There are no Visualization tasks, subjective judges, or manually graded
criteria.

## Operators and scaling

[`spreadsheet_eval/mutation_operators.py`](spreadsheet_eval/mutation_operators.py)
contains the reusable operators:

- `blank_formula`: remove genuine formulas across up to six formula-rich sheets
  to trigger zero/partial coverage and long-horizon execution failures;
- `sign_flip`: retain local syntax while reversing financial semantics;
- `offset`: wrap a correct formula in a plausible `1 + (...)` corruption;
- `reference_drift`: move one real cell reference by one row;
- deterministic cross-sheet target selection, seeded per source workbook.

The mutation budget scales with the workbook's real formula count. Financial
tasks require 60-140 exact formula restorations; debugging tasks contain 24-32
sparse, heterogeneous faults. Each `tests/manifest.json` stores the complete
cell-level before/injected/reference audit log. The generator never calls a
model or asks a human to choose cells.

## Strict verifier

Each task reward is exactly 0 or 1. The verifier:

1. rejects a missing `/workspace/output.xlsx`;
2. requires sheet names/order/state, dimensions, merged ranges, and freeze
   panes to remain unchanged;
3. computes the raw changed-cell set and requires exact equality with ground
   truth - one missing or extra cell is reward 0;
4. recalculates the candidate and reference with LibreOffice;
5. normalizes dates and compares numeric values rounded to two decimals;
6. provides no partial credit.

Both an unchanged input and an Oracle workbook with one extra edit were tested
and score 0. The unmodified Oracle copies `reference.xlsx` to `output.xlsx` and
scores 1 on all ten tasks.

## Reproduce

Requirements: Python 3.11, Docker, LibreOffice-capable Harbor, and `curl`.

```bash
python3.11 -m venv .venv311
.venv311/bin/python -m pip install -e '.[test]'

docker build -f SWE-agent/spreadsheet.Dockerfile \
  -t spreadsheetbench-v2 SWE-agent/docker-context

bash scripts/fetch_real_workbooks.sh
.venv311/bin/python scripts/generate_real_spreadsheet_eval.py
.venv311/bin/python -m pytest -q tests
```

Run the official Oracle:

```bash
harbor run -p SpreadsheetEval -a oracle --n-concurrent 1 \
  --job-name real-oracle -o jobs -y
```

Run and monitor DeepSeek. `DEEPSEEK_API_KEY` may be exported, or on macOS it
may be stored in Keychain under service `spreadsheetbench-v2-deepseek`.

```bash
bash scripts/run_construction_eval.sh real-deepseek-full
bash scripts/monitor_construction_eval.sh real-deepseek-full 60
python scripts/analyze_harbor_results.py real-deepseek-full
python scripts/export_evaluation_artifacts.py real-deepseek-full
python scripts/replay_final_verifier.py real-deepseek-full
```

The exporter refuses partial or errored runs. Committed evaluation artifacts
contain each complete ATIF trajectory JSON, terminal recording, terminal pane,
trial metadata, candidate `output.xlsx`, verifier evidence, monitor history,
and aggregate result. No API key is written to the repository.

## Repository map

```text
SpreadsheetEval/                 10 runnable Harbor tasks
spreadsheet_eval/                real-workbook generator, operators, verifier
scripts/                         fetch, generate, run, monitor, analyze, export
reports/                         original and constructed case analyses
evaluation_artifacts/            complete 10-task model trajectories
third_party/real_workbooks/      provenance and license texts
tests/                           invariants, provenance, operator tests
```

Detailed design notes are in
[`README_CONSTRUCTION.md`](README_CONSTRUCTION.md). The original upstream
SpreadsheetBench V2 instructions are preserved in
[`README_UPSTREAM.md`](README_UPSTREAM.md).
