from __future__ import annotations

import random
import re


def choose_across_sheets(
    formula_cells: dict[str, list], total: int, seed: int
) -> list[tuple[str, str]]:
    """Select deterministic targets across the six richest formula sheets."""
    rng = random.Random(seed)
    sheets = sorted(
        formula_cells, key=lambda sheet: len(formula_cells[sheet]), reverse=True
    )[:6]
    chosen: list[tuple[str, str]] = []
    quota = max(8, total // max(1, len(sheets)))
    for name in sheets:
        cells = list(formula_cells[name])
        rng.shuffle(cells)
        chosen.extend((name, cell.coordinate) for cell in cells[:quota])
    remaining = [
        (sheet, cell.coordinate)
        for sheet in sheets
        for cell in formula_cells[sheet]
        if (sheet, cell.coordinate) not in chosen
    ]
    rng.shuffle(remaining)
    chosen.extend(remaining[: max(0, total - len(chosen))])
    return chosen[:total]


def blank_formula(workbook, sheet: str, coordinate: str) -> dict:
    """Remove one genuine formula for a template-completion task."""
    reference = workbook[sheet][coordinate].value
    workbook[sheet][coordinate].value = None
    return {
        "sheet": sheet,
        "cell": coordinate,
        "operator": "blank_formula",
        "reference": reference,
    }


def mutate_formula(formula: str, kind: str) -> str:
    """Inject one locally plausible but semantically wrong formula."""
    body = formula[1:]
    if kind == "sign_flip":
        return f"=-1*({body})"
    if kind == "offset":
        return f"=1+({body})"
    if kind == "reference_drift":
        match = re.search(r"(?<![A-Z0-9_])([$]?[A-Z]{1,3})([$]?)(\d+)", body)
        if match:
            row = int(match.group(3)) + 1
            body = (
                body[: match.start()]
                + f"{match.group(1)}{match.group(2)}{row}"
                + body[match.end() :]
            )
            return "=" + body
    return f"=0+({body})+1"


def inject_formula_fault(workbook, sheet: str, coordinate: str, kind: str) -> dict:
    """Apply a debugging mutation while retaining both sides of the audit log."""
    reference = workbook[sheet][coordinate].value
    injected = mutate_formula(reference, kind)
    workbook[sheet][coordinate].value = injected
    return {
        "sheet": sheet,
        "cell": coordinate,
        "operator": kind,
        "reference": reference,
        "injected": injected,
    }
