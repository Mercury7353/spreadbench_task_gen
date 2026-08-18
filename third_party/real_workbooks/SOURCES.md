# Real workbook provenance

The final benchmark is derived from existing human-authored Excel financial
models. The workbooks are not programmatically invented; code only normalizes
the file format and applies auditable task mutations.

## IanMadlenya/finance-excel

- Repository: https://github.com/IanMadlenya/finance-excel
- Pinned commit: `eca3d98f1984fde1e149ce023ec55a72c8c0ada8`
- License: Apache-2.0 (preserved in `finance-excel/LICENSE`)
- Used files:
  - `5 Year Financial Plan for Manufacturing Company.xls`
  - `Commercial Real Estate Valuation Model.xls`
  - `Coal India Limited Financial Model & Valuation.xls`
  - `Financial Projection Model.xls`
- Conversion: LibreOffice headless, `.xls` to `.xlsx`.

## Packt project-finance workbook

- Repository: https://github.com/PacktPublishing/Project-Finance-and-Excel---Build-Financial-Models-from-Scratch
- Pinned commit: `618787e67a7ee0e6643f60ef447a9c35d6ee9301`
- License: MIT (preserved in `packt-project-finance/LICENSE`)
- Used file: `Financial+Model.xlsx`

## Rejected during audit

- `European RMBS Cash Flow Model.xls`: converted XML could not be parsed safely.
- `Apple LBO Model.xls`: legacy shared/array formulas produced untracked
  serialization differences.
- `Extended Leveraged Buyout Model.xls`: three legacy formula cells produced
  untracked serialization differences.

Rejected workbooks are not included in `SpreadsheetEval`.

## Accepted converted-workbook checksums

| Workbook | Sheets | Formulas | SHA-256 |
|---|---:|---:|---|
| `5 Year Financial Plan for Manufacturing Company.xlsx` | 5 | 1,875 | `c91b655930980b7143bb81f8f73dd792141802f53e6293341b1ca1f66c3a332d` |
| `Commercial Real Estate Valuation Model.xlsx` | 2 | 321 | `d7283ab5fe31790bf399c7a4451b7a226eb8f3c4085c98ea13232cd2b5830683` |
| `Coal India Limited Financial Model & Valuation.xlsx` | 11 | 1,562 | `dffbc17d6b21b1ad3f137e2a2b1d9542c142624628838d23688a9aed5783934e` |
| `Financial Projection Model.xlsx` | 22 | 3,865 | `db46363a46b342fd7500e913fd6ae7fa5bfbc6820ea8634f8be2029b637b7d32` |
| `Packt_Project_Finance.xlsx` | 10 | 2,973 | `d8de77e6af2da56983101b74d3099ca77a9641dd7bd89f3cb76f03425c4a5acc` |
