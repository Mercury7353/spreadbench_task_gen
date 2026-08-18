#!/usr/bin/env python3
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root))

from spreadsheet_eval.original_analysis import analyze_template, write_reports

rows = analyze_template(root)
write_reports(rows, root / "reports")
print(f"Analyzed {len(rows)} original Template cases")
