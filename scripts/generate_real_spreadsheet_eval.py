#!/usr/bin/env python3
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root))

from spreadsheet_eval.real_generator import RealWorkbookBuilder

rows = RealWorkbookBuilder(
    root / "SpreadsheetEval", root / ".cache/real_workbooks/converted"
).build()
print(f"Generated {len(rows)} real-workbook Harbor tasks")
