# real-deepseek-full: case-by-case failure analysis

This report joins each complete model trajectory to the strict verifier result and the original SpreadsheetBench V2 cases that motivated the task.

## Aggregate bad patterns

- `incomplete-target-coverage`: 7/10
- `over-editing`: 6/10
- `false-completion-confidence`: 4/10
- `precision-recall-tradeoff`: 3/10

## `spreadsheet-eval/debugging-01-manufacturing-plan`

- Reward: `0.0`; required edits: 26; trajectory steps/tool calls: 34/36
- Original evidence cases: 01_02, 01_04; target weaknesses: incomplete-target-coverage, over-editing, numerical-looping, context-bloat
- Tokens: 873,715 input (812,160 cached) / 32,660 output; cost: $0.020037
- Observed bad patterns: over-editing
- Exact verifier delta: 0 missing, 14 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/debugging-01-manufacturing-plan/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [],
  "extra": [
    "Balance Sheet!D43",
    "Balance Sheet!E43",
    "Balance Sheet!F43",
    "Balance Sheet!G43",
    "Balance Sheet!H43",
    "Balance Sheet!I43",
    "Model Inputs!C31",
    "Model Inputs!C33",
    "Model Inputs!D31",
    "Model Inputs!D33",
    "Model Inputs!E31",
    "Model Inputs!E33",
    "Model Inputs!F31",
    "Model Inputs!F33"
  ]
}
```

</details>

## `spreadsheet-eval/debugging-02-commercial-real-estate`

- Reward: `0.0`; required edits: 24; trajectory steps/tool calls: 15/15
- Original evidence cases: 02_02, 02_05; target weaknesses: incomplete-target-coverage, over-editing
- Tokens: 245,810 input (219,776 cached) / 6,618 output; cost: $0.006113
- Observed bad patterns: false-completion-confidence, over-editing
- Exact verifier delta: 0 missing, 10 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/debugging-02-commercial-real-estate/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [],
  "extra": [
    "Model!E61",
    "Model!F60",
    "Model!F61",
    "Model!G61",
    "Model!H61",
    "Model!I61",
    "Model!J61",
    "Model!L61",
    "Model!M61",
    "Model!N61"
  ]
}
```

</details>

## `spreadsheet-eval/debugging-03-coal-india`

- Reward: `0.0`; required edits: 24; trajectory steps/tool calls: 49/60
- Original evidence cases: 03_01, 03_03; target weaknesses: incomplete-target-coverage, over-editing
- Tokens: 1,664,565 input (1,609,600 cached) / 19,677 output; cost: $0.017712
- Observed bad patterns: incomplete-target-coverage
- Exact verifier delta: 1 missing, 0 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/debugging-03-coal-india/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [
    "P&L!K59"
  ],
  "extra": []
}
```

</details>

## `spreadsheet-eval/debugging-04-financial-projection`

- Reward: `0.0`; required edits: 32; trajectory steps/tool calls: 67/72
- Original evidence cases: 05_01, 05_02; target weaknesses: incomplete-target-coverage, over-editing, exactness-near-miss
- Tokens: 4,166,022 input (4,067,072 cached) / 23,332 output; cost: $0.031774
- Observed bad patterns: false-completion-confidence, incomplete-target-coverage, over-editing, precision-recall-tradeoff
- Exact verifier delta: 7 missing, 49 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/debugging-04-financial-projection/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [
    "12. Income Statement (2)!B10",
    "12. Income Statement (2)!E41",
    "12. Income Statement (2)!H60",
    "15. Income Statement (3)!E41",
    "15. Income Statement (3)!F19",
    "15. Income Statement (3)!P42",
    "8. Income Statement!L60"
  ],
  "extra": [
    "17. Balance Sheet (3)!I13",
    "4. Projected Sales Forecast!H37",
    "4. Projected Sales Forecast!H38",
    "4. Projected Sales Forecast!I37",
    "4. Projected Sales Forecast!I38",
    "4. Projected Sales Forecast!J37",
    "4. Projected Sales Forecast!J38",
    "4. Projected Sales Forecast!K37",
    "4. Projected Sales Forecast!K38",
    "4. Projected Sales Forecast!L37",
    "4. Projected Sales Forecast!L38",
    "4. Projected Sales Forecast!M37",
    "4. Projected Sales Forecast!M38",
    "4. Projected Sales Forecast!N37",
    "4. Projected Sales Forecast!N38",
    "4. Projected Sales Forecast!O37",
    "4. Projected Sales Forecast!O38",
    "4. Projected Sales Forecast!P37",
    "4. Projected Sales Forecast!P38",
    "4. Projected Sales Forecast!Q37",
    "4. Projected Sales Forecast!Q38",
    "4. Projected Sales Forecast!R37",
    "4. Projected Sales Forecast!R38",
    "4. Projected Sales Forecast!S37",
    "4. Projected Sales Forecast!S38",
    "5. Projected Sales Forecast (2)!H37",
    "5. Projected Sales Forecast (2)!H38",
    "5. Projected Sales Forecast (2)!I37",
    "5. Projected Sales Forecast (2)!I38",
    "5. Projected Sales Forecast (2)!J37",
    "5. Projected Sales Forecast (2)!J38",
    "5. Projected Sales Forecast (2)!K37",
    "5. Projected Sales Forecast (2)!K38",
    "5. Projected Sales Forecast (2)!L37",
    "5. Projected Sales Forecast (2)!L38",
    "5. Projected Sales Forecast (2)!M37",
    "5. Projected Sales Forecast (2)!M38",
    "5. Projected Sales Forecast (2)!N37",
    "5. Projected Sales Forecast (2)!N38",
    "5. Projected Sales Forecast (2)!O37",
    "5. Projected Sales Forecast (2)!O38",
    "5. Projected Sales Forecast (2)!P37",
    "5. Projected Sales Forecast (2)!P38",
    "5. Projected Sales Forecast (2)!Q37",
    "5. Projected Sales Forecast (2)!Q38",
    "5. Projected Sales Forecast (2)!R37",
    "5. Projected Sales Forecast (2)!R38",
    "5. Projected Sales Forecast (2)!S37",
    "5. Projected Sales Forecast (2)!S38"
  ]
}
```

</details>

## `spreadsheet-eval/debugging-05-project-finance`

- Reward: `0.0`; required edits: 32; trajectory steps/tool calls: 51/82
- Original evidence cases: 06_06, 06_08; target weaknesses: incomplete-target-coverage, over-editing, context-bloat
- Tokens: 1,833,820 input (1,784,320 cached) / 21,228 output; cost: $0.017870
- Observed bad patterns: false-completion-confidence, incomplete-target-coverage
- Exact verifier delta: 7 missing, 0 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/debugging-05-project-finance/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [
    "CFS!L23",
    "CFS!R14",
    "Construction!AB16",
    "P&L!AP11",
    "Ratios!AC12",
    "Ratios!AI10",
    "Ratios!Y15"
  ],
  "extra": []
}
```

</details>

## `spreadsheet-eval/financial-01-manufacturing-plan`

- Reward: `0.0`; required edits: 140; trajectory steps/tool calls: 29/27
- Original evidence cases: 04_04, 06_01; target weaknesses: zero-target-coverage
- Tokens: 560,008 input (526,208 cached) / 16,187 output; cost: $0.010738
- Observed bad patterns: incomplete-target-coverage, over-editing, precision-recall-tradeoff
- Exact verifier delta: 22 missing, 2 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/financial-01-manufacturing-plan/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [
    "Balance Sheet!E32",
    "Balance Sheet!F11",
    "Balance Sheet!F22",
    "Balance Sheet!F24",
    "Balance Sheet!F29",
    "Balance Sheet!F7",
    "Balance Sheet!G18",
    "Balance Sheet!G31",
    "Balance Sheet!G47",
    "Cash Flow!E29",
    "Cash Flow!F26",
    "Cash Flow!F8",
    "Cash Flow!G21",
    "Cash Flow!G35",
    "Cash Flow!H11",
    "Cash Flow!I12",
    "Cash Flow!I21",
    "Model Inputs!C31",
    "Model Inputs!D31",
    "Model Inputs!E31",
    "Model Inputs!F31",
    "Profit and Loss!B2"
  ],
  "extra": [
    "Cash Flow!I35",
    "Cash Flow!I36"
  ]
}
```

</details>

## `spreadsheet-eval/financial-02-commercial-real-estate`

- Reward: `0.0`; required edits: 60; trajectory steps/tool calls: 16/17
- Original evidence cases: 06_02, 06_03; target weaknesses: zero-target-coverage
- Tokens: 354,625 input (317,440 cached) / 16,572 output; cost: $0.010735
- Observed bad patterns: false-completion-confidence, over-editing
- Exact verifier delta: 0 missing, 1 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/financial-02-commercial-real-estate/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [],
  "extra": [
    "Model!D72"
  ]
}
```

</details>

## `spreadsheet-eval/financial-03-coal-india`

- Reward: `0.0`; required edits: 130; trajectory steps/tool calls: 33/32
- Original evidence cases: 06_04, 06_05; target weaknesses: zero-target-coverage, incomplete-target-coverage
- Tokens: 1,816,658 input (1,779,456 cached) / 34,746 output; cost: $0.019920
- Observed bad patterns: incomplete-target-coverage
- Exact verifier delta: 53 missing, 0 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/financial-03-coal-india/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [
    "Assumptions!I60",
    "BS!F40",
    "BS!F9",
    "BS!K18",
    "BS!K21",
    "BS!K33",
    "BS!O39",
    "BS!O4",
    "BS!O40",
    "CF!G12",
    "CF!G33",
    "CF!J7",
    "CF!N42",
    "CF!O10",
    "CF!O32",
    "CF!O42",
    "P&L!G22",
    "P&L!J22",
    "P&L!K7",
    "P&L!O28",
    "P&L!O33",
    "P&L!O34",
    "Reserves!F13",
    "Reserves!F4",
    "Reserves!G10",
    "Reserves!K11",
    "Reserves!K9",
    "Reserves!N13",
    "Reserves!O13",
    "Reserves!O19",
    "Valuation!G14",
    "Valuation!H19",
    "Valuation!I20",
    "Valuation!L19",
    "Valuation!L24",
    "Valuation!L41",
    "Valuation!L43",
    "Valuation!L53",
    "Valuation!M11",
    "Valuation!M14",
    "Valuation!M20",
    "Valuation!M35",
    "Valuation!M47",
    "Valuation!M54",
    "Valuation!O16",
    "Valuation!P39",
    "Valuation!R40",
    "Valuation!S44",
    "Valuation!T37",
    "Valuation!T40",
    "Valuation!U42",
    "Valuation!V34",
    "Valuation!V54"
  ],
  "extra": []
}
```

</details>

## `spreadsheet-eval/financial-04-financial-projection`

- Reward: `0.0`; required edits: 140; trajectory steps/tool calls: 68/101
- Original evidence cases: 07_01, 07_02; target weaknesses: zero-target-coverage, no-deliverable, tool-protocol
- Tokens: 3,884,367 input (3,793,152 cached) / 33,546 output; cost: $0.032784
- Observed bad patterns: incomplete-target-coverage, over-editing, precision-recall-tradeoff
- Exact verifier delta: 3 missing, 22 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/financial-04-financial-projection/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [
    "13. Cash Flow Statement (2)!Q28",
    "15. Income Statement (3)!B10",
    "15. Income Statement (3)!B52"
  ],
  "extra": [
    "12. Income Statement (2)!Q70",
    "12. Income Statement (2)!Q71",
    "13. Cash Flow Statement (2)!Q37",
    "13. Cash Flow Statement (2)!Q8",
    "15. Income Statement (3)!Q70",
    "15. Income Statement (3)!Q71",
    "16. Cash Flow Statement (3)!Q33",
    "16. Cash Flow Statement (3)!Q37",
    "16. Cash Flow Statement (3)!Q40",
    "16. Cash Flow Statement (3)!Q8",
    "20. Amoritization Schedule!S17",
    "20. Amoritization Schedule!S21",
    "20. Amoritization Schedule!S25",
    "20. Amoritization Schedule!S37",
    "20. Amoritization Schedule!S41",
    "20. Amoritization Schedule!S45",
    "8. Income Statement!Q70",
    "8. Income Statement!Q71",
    "9. Cash Flow Statement!Q33",
    "9. Cash Flow Statement!Q37",
    "9. Cash Flow Statement!Q40",
    "9. Cash Flow Statement!Q8"
  ]
}
```

</details>

## `spreadsheet-eval/financial-05-project-finance`

- Reward: `0.0`; required edits: 140; trajectory steps/tool calls: 34/33
- Original evidence cases: 11_01, 11_02; target weaknesses: zero-target-coverage
- Tokens: 1,284,921 input (1,239,040 cached) / 17,611 output; cost: $0.014824
- Observed bad patterns: incomplete-target-coverage
- Exact verifier delta: 12 missing, 0 extra, 0 value errors.
- Complete trajectory: `evaluation_artifacts/real-deepseek-full/financial-05-project-finance/trajectory.json`

<details><summary>Full verifier evidence</summary>

```json
{
  "reason": "modified_set_mismatch",
  "missing": [
    "Balance Sheet!F14",
    "CFS!AS25",
    "Operation!AC20",
    "Operation!AD20",
    "Operation!K14",
    "Operation!L14",
    "Operation!M21",
    "Operation!N21",
    "Operation!S8",
    "Operation!T8",
    "P&L!AS23",
    "Ratios!F16"
  ],
  "extra": []
}
```

</details>

