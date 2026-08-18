# Local SpreadsheetBench 2 setup

This checkout is configured for DeepSeek's `deepseek-chat` model through LiteLLM.
The repository never stores the API key. `scripts/run_deepseek.sh` reads
`DEEPSEEK_API_KEY`, falling back to the macOS Keychain service
`spreadsheetbench-v2-deepseek`.

## Install and build

```bash
./scripts/setup_local.sh
```

The official runtime requires Docker. On macOS, start Docker Desktop or Colima
before rerunning the setup script so it can build `spreadsheetbench-v2`.

## Dataset

Download `KAKA22/SpreadsheetBench-v2` into:

```text
data/spreadsheetbench-v2/
  Debugging/
  Financial_Model/
  Template/
  Visualization/
```

Or run:

```bash
conda activate ssb-v2
./scripts/download_data.sh
```

## Run

Start with one worker to control API spend:

```bash
conda activate ssb-v2
NUM_WORKERS=1 ./scripts/run_deepseek.sh Template
```

Valid categories are `Debugging`, `Financial_Model`, `Template`, and
`Visualization`. Visualization inference works on macOS, but the official chart
evaluation requires Windows Excel/WPS COM and a separate GLM-4.6V judge key.

To run all 321 tasks sequentially while keeping category-specific trajectories:

```bash
conda activate ssb-v2
NUM_WORKERS=1 ./scripts/run_all_deepseek.sh
```

The full-run wrapper checks free disk space before every category and stops if
less than 8 GiB remains.

## Trajectories

Every run gets a UTC run ID and is stored under:

```text
trajectories/deepseek-chat/<run-id>/<Category>/
```

The directory retains per-task `.traj` files, task configs, logs, predictions,
tool observations, model messages, costs/tokens, exit statuses, generated Excel
files, and a `run-manifest.txt` containing the dataset checksum and repository
revision. `latest-<Category>` points to the newest run without overwriting older
runs. The entire `trajectories/` tree is git-ignored because trajectories can
contain workbook data and model prompts.
