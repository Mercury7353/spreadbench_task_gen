#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RAW="$ROOT/.cache/real_workbooks/raw"
OUT="$ROOT/.cache/real_workbooks/converted"
mkdir -p "$RAW" "$OUT"

download() {
  local url="$1" output="$2"
  curl -L --fail --retry 3 --output "$output" "$url"
}

finance_commit="eca3d98f1984fde1e149ce023ec55a72c8c0ada8"
base="https://raw.githubusercontent.com/IanMadlenya/finance-excel/$finance_commit"
download "$base/5%20Year%20Financial%20Plan%20for%20Manufacturing%20Company.xls" "$RAW/5 Year Financial Plan for Manufacturing Company.xls"
download "$base/Commercial%20Real%20Estate%20Valuation%20Model.xls" "$RAW/Commercial Real Estate Valuation Model.xls"
download "$base/Coal%20India%20Limited%20Financial%20Model%20%26%20Valuation.xls" "$RAW/Coal India Limited Financial Model & Valuation.xls"
download "$base/Financial%20Projection%20Model.xls" "$RAW/Financial Projection Model.xls"
download "$base/LICENSE" "$RAW/finance-excel-LICENSE"

packt_commit="618787e67a7ee0e6643f60ef447a9c35d6ee9301"
packt="https://raw.githubusercontent.com/PacktPublishing/Project-Finance-and-Excel---Build-Financial-Models-from-Scratch/$packt_commit"
download "$packt/Financial%2BModel.xlsx" "$OUT/Packt_Project_Finance.xlsx"
download "$packt/LICENSE" "$RAW/packt-LICENSE"

docker run --rm \
  -v "$RAW:/in:ro" \
  -v "$OUT:/out" \
  spreadsheetbench-v2 bash -lc \
  'for f in /in/*.xls; do libreoffice --headless --convert-to xlsx --outdir /out "$f"; done'

echo "Real workbooks prepared under $OUT"
