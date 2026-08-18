# SpreadsheetEval：基于真实复杂 Excel 与原始失败轨迹构造的 Harbor 评测集

本仓库是笔试题 **SpreadsheetBench construction (Harbor)** 的完整交付。最终数据集包含 **10 道可程序化验证的 OJ-style Spreadsheet Agent 任务**：5 道 Financial Modeling、5 道 Debugging。所有题目均以真实、人类编写的复杂财务工作簿为母本；代码只对真实公式图进行可审计、可复现的变异，不使用 SpreadsheetBench 官方原题，也不从零程序化伪造简单 Excel。

最终验收结果：Harbor Oracle **10/10 = 1.000**，DeepSeek `deepseek-chat` **0/10 = 0.000**，满足题目要求的 Overall Pass@1 ≤ 0.2。10 个模型候选文件经过最终 verifier 独立重放后仍为 **0/10**，完整轨迹、终端录像、候选工作簿和逐 cell 验证结果均已提交。

## 1. 对照题目 PDF 的交付验收表

| PDF 硬性要求 | 本仓库实现 | 可核验证据 |
|---|---|---|
| Financial Modeling ≥ 5，Debugging ≥ 5，总计 ≥ 10 | 恰好 5 + 5，共 10 道 | [`SpreadsheetEval/dataset_manifest.json`](SpreadsheetEval/dataset_manifest.json)、[`test_dataset_shape`](tests/test_generation.py#L9-L14) |
| 只做可程序化验证的 OJ-style exact match | 所有 task 的 reward 只能是 0/1；没有图表、主观美观度或人工 judge | [`verifier.py`](spreadsheet_eval/verifier.py#L90-L149)、[`SpreadsheetEval/`](SpreadsheetEval/) |
| 提交模型 Overall Pass@1 ≤ 0.2 | DeepSeek 0/10 = **0.000**，低于 0.2 | [`aggregate-result.json`](evaluation_artifacts/real-deepseek-full/aggregate-result.json)、[`final-verifier-replay.json`](evaluation_artifacts/real-deepseek-full/final-verifier-replay.json) |
| 风格对齐 SpreadsheetBench v2：多 sheet、跨表、修改量大、真实业务语义 | 母本有 2-22 个 sheet、321-3,865 个真实公式；Financial 每题需精确恢复 60-140 个公式 | [`dataset_manifest.json`](SpreadsheetEval/dataset_manifest.json)、[母本来源与哈希](third_party/real_workbooks/SOURCES.md) |
| 比较 LibreOffice 重算后的值，而非公式字符串 | 候选与 reference 均先经 LibreOffice headless 重算，再用 `data_only=True` 读取 | [`recalc`](spreadsheet_eval/verifier.py#L18-L39)、[`values`](spreadsheet_eval/verifier.py#L80-L87) |
| 数值保留两位小数，日期归一化 | 数值 `round(..., 2)`；日期统一为 `YYYY-MM-DD` | [`norm`](spreadsheet_eval/verifier.py#L68-L77)、[`test_numeric_normalization`](tests/test_verifier.py#L9-L12) |
| 修改集合必须严格等于 ground truth；多改、少改都判 0 | 先比较原始 cell map，`changed != required` 立即 reward 0，并输出 missing/extra | [`modified_set_mismatch`](spreadsheet_eval/verifier.py#L113-L129) |
| 单 task reward 为 0/1，禁止部分给分；dataset score 为均值 | verifier 只写 `0` 或 `1`；Harbor 聚合为十题均值 | [`reward`](spreadsheet_eval/verifier.py#L140-L149)、[`aggregate-result.json`](evaluation_artifacts/real-deepseek-full/aggregate-result.json) |
| 造题方案必须可 scaling，不允许人工参与 | 固定 seed 跨表选点，变异预算随母本真实公式量缩放；生成器一次产生全部 10 题 | [`choose_across_sheets`](spreadsheet_eval/mutation_operators.py#L7-L29)、[`RealWorkbookBuilder`](spreadsheet_eval/real_generator.py#L135-L235) |
| 绝对不能使用官方原题 | 原评测只提供弱点标签；题目 Excel 来自两个许可开放仓库，带固定 commit、SHA-256 和许可证 | [`SOURCES.md`](third_party/real_workbooks/SOURCES.md)、[`validate_provenance`](spreadsheet_eval/provenance.py#L38-L73) |
| 每题包含 `instruction.md`、`task.toml`、`environment/`、`solution/`、`tests/test.sh` | 10 道题全部具备完整 Harbor 目录和可执行脚本 | [`test_harbor_layout_and_oracle_payloads`](tests/test_generation.py#L17-L41)、[一题完整示例](SpreadsheetEval/debugging-03-coal-india/) |
| Oracle reference 必须由程序构造，且全部 reward = 1.0 | 生成器从归一化母本产生 reference；Oracle 复制 reference；最终 10/10 | [`reference 构造`](spreadsheet_eval/real_generator.py#L158-L199)、[`solve.sh`](SpreadsheetEval/debugging-03-coal-india/solution/solve.sh)、[`real-oracle-final-result.json`](reports/real-oracle-final-result.json) |
| README 至少含方案解读、模型分数表、Harbor 命令、失败 case 分析 | 本 README 第 2-10 节逐项覆盖，并链接到完整报告与轨迹 | 本文件及 [`reports/`](reports/) |

## 2. 我是如何完成这道题的

整体链路不是“先随便造题，再把题调难”，而是：

```text
原始 SpreadsheetBench V2 评测轨迹
        ↓ 逐 case 读取并标注失败模式
弱点 taxonomy + 原始 case 证据
        ↓
收集真实、复杂、许可清晰的 Excel 母本
        ↓
弱点驱动的确定性变异算子
        ↓
生成 input/reference/manifest/Harbor task
        ↓
Oracle + 负例 + 结构保护验证
        ↓
DeepSeek 全量运行、定时监控、轨迹导出
        ↓
逐 case 阅读候选文件和 verifier delta
        ↓
最终 verifier 重放与指标冻结
```

对应入口分别是：

- 原始轨迹分析：[`scripts/analyze_original_template.py`](scripts/analyze_original_template.py) 和 [`spreadsheet_eval/original_analysis.py`](spreadsheet_eval/original_analysis.py)；
- 母本下载：[`scripts/fetch_real_workbooks.sh`](scripts/fetch_real_workbooks.sh)；
- 变异算子：[`spreadsheet_eval/mutation_operators.py`](spreadsheet_eval/mutation_operators.py)；
- 数据集生成：[`scripts/generate_real_spreadsheet_eval.py`](scripts/generate_real_spreadsheet_eval.py) 和 [`spreadsheet_eval/real_generator.py`](spreadsheet_eval/real_generator.py)；
- 严格验证：[`spreadsheet_eval/verifier.py`](spreadsheet_eval/verifier.py)；
- Harbor 运行与监控：[`scripts/run_construction_eval.sh`](scripts/run_construction_eval.sh)、[`scripts/monitor_construction_eval.sh`](scripts/monitor_construction_eval.sh)；
- 结果分析与轨迹固化：[`scripts/analyze_harbor_results.py`](scripts/analyze_harbor_results.py)、[`scripts/export_evaluation_artifacts.py`](scripts/export_evaluation_artifacts.py)、[`scripts/replay_final_verifier.py`](scripts/replay_final_verifier.py)。

## 3. 第一步：从原始评测逐 case 提取模型弱点

我读取了原始 SpreadsheetBench V2 Template split 已完成的 **97/97 条轨迹**，并将每条轨迹与官方 regression/modification accuracy、退出状态、工具调用、首个 evaluator error 对齐。逐 case 冻结结果位于：

- 人类可读版：[`reports/original_template_97_cases.md`](reports/original_template_97_cases.md)；
- 机器可读版：[`reports/original_template_97_cases.json`](reports/original_template_97_cases.json)。

原始模型只通过 **7/97 = 0.0722**。失败标签允许重叠，因此各项之和大于 97：

| 原始失败模式 | case 数 | 对造题的直接启发 |
|---|---:|---|
| zero-target-coverage | 63 | 用大规模真实公式缺失触发“没有完成核心修改” |
| incomplete-target-coverage | 27 | 把目标稀疏分布到多个 sheet、内部与边缘位置 |
| over-editing | 27 | 要求“只改错误 cell”，并用严格 changed-set 拒绝合理但多余的修改 |
| context-bloat | 15 | 使用 10-22 sheet 的长上下文母本与跨表依赖 |
| no-deliverable | 12 | verifier 首先检查 `/workspace/output.xlsx` 是否存在 |
| numerical-looping | 11 | 使用真实财务模型中的循环推导、滚动期间和多 statement 关系 |
| tool-protocol | 8 | 完整 Harbor 环境要求模型真正操作并保存工作簿 |
| budget-exhaustion | 5 | Financial task 扩大到 60-140 个精确目标 |
| exactness-near-miss | 3 | 采用“一处多改或少改即 0 分”的 OJ 判定 |

具体例子：原始 case `01_01` 在 51 次 API 调用、732,806 tokens 后仍没有输出文件，因此被标记为 `budget-exhaustion + context-bloat + no-deliverable + numerical-looping + zero-target-coverage`。这类证据不是只写在报告里；每个新 task 的 [`tests/manifest.json`](SpreadsheetEval/debugging-01-manufacturing-plan/tests/manifest.json) 都嵌入 `source_original_cases`、`weaknesses` 和当时的完整标签。生成后的 [`validate_provenance`](spreadsheet_eval/provenance.py#L38-L73) 会拒绝不存在的 case、过期标签或没有原始证据支持的弱点。

## 4. 第二步：只收集真实复杂 Excel，不程序化伪造母本

遵照“尽量收集现有复杂 Excel”的约束，最终选取 5 个真实、人类编写的财务模型。四个来自 `IanMadlenya/finance-excel`（Apache-2.0），一个来自 Packt 项目财务仓库（MIT）。仓库 commit、原始 URL、转换后 SHA-256、许可证和被淘汰母本的理由都记录在 [`third_party/real_workbooks/SOURCES.md`](third_party/real_workbooks/SOURCES.md)。

| 真实母本 | Sheet 数 | 真实公式数 | Financial 精确修改 | Debugging 精确修改 | 业务语义 |
|---|---:|---:|---:|---:|---|
| Five-year manufacturing plan | 5 | 1,875 | 140 | 26 | P&L、Balance Sheet、Cash Flow、贷款计划 |
| Commercial real-estate valuation | 2 | 321 | 60 | 24 | 房地产现金流、债务服务与估值 |
| Coal India financial model | 11 | 1,562 | 130 | 24 | 假设、三表、估值和敏感性分析 |
| Financial projection model | 22 | 3,865 | 140 | 32 | 多版本销售预测、损益表、资产负债表 |
| Packt project-finance model | 10 | 2,973 | 140 | 32 | 建设期、运营期、摊销、债务、三表和 ratios |

这 5 个母本各生成 1 道 Financial + 1 道 Debugging，正好得到 10 道题。数据集一共要求 **748 个精确修改 cell**，平均每题 74.8 个；Financial 平均 122 个，Debugging 平均 27.6 个。

## 5. 第三步：弱点驱动的可扩展算子

### 5.1 跨表确定性选点

[`choose_across_sheets`](spreadsheet_eval/mutation_operators.py#L7-L29) 先按公式量选择最多 6 个最丰富的 sheet，再以固定 seed 分配 quota 和补充目标。因此同一母本每次生成完全相同，但更换母本、seed 或预算即可横向扩展。没有人工逐 cell 挑题。

### 5.2 Financial Modeling：真实公式缺失

[`blank_formula`](spreadsheet_eval/mutation_operators.py#L32-L41) 从 reference 中移除真实公式，并在 manifest 中保存原公式。预算根据真实公式数缩放：

```python
min(140, max(60, available_formula_count // 12))
```

对应实现见 [`real_generator.py`](spreadsheet_eval/real_generator.py#L176-L184)。这不是生成一个空白小表，而是在 321-3,865 条真实公式的既有模型中制造 60-140 个跨 sheet 缺口，触发原始评测中的 zero/incomplete target coverage。

### 5.3 Debugging：局部合法、语义错误的公式

[`mutate_formula`](spreadsheet_eval/mutation_operators.py#L44-L61) 循环使用三类 fault：

| 算子 | 注入方式 | 为什么难发现 |
|---|---|---|
| `sign_flip` | `=X` → `=-1*(X)` | 公式可计算，但财务方向相反 |
| `offset` | `=X` → `=1+(X)` | 不产生 `#REF!`，只造成细微数值漂移 |
| `reference_drift` | 首个真实引用的行号 `r` → `r+1` | 公式结构正常，引用了相邻但错误的业务行 |

Debugging 预算按 `min(32, max(24, formula_count // 70))` 缩放，见 [`real_generator.py`](spreadsheet_eval/real_generator.py#L185-L195)。每条 mutation 都保留 `reference` 和 `injected` 两侧，完整 cell 审计日志位于每题的 `tests/manifest.json`。

一个真实注入例子是 [`debugging-03-coal-india/tests/manifest.json`](SpreadsheetEval/debugging-03-coal-india/tests/manifest.json)：`P&L!K59` 原公式为 `=J59`，`reference_drift` 将其改为 `=J60`。工作簿仍可正常重算，也没有公式错误字符串，但业务引用已经错误；最终 DeepSeek 正好漏掉了这个 cell。

## 6. 第四步：程序化生成完整 Harbor task

[`RealWorkbookBuilder`](spreadsheet_eval/real_generator.py#L135-L235) 对每个母本执行以下步骤：

1. 用 `openpyxl` 做两轮稳定化 round-trip，消除 legacy shared/array formula 在独立保存时产生的非题目差异；
2. 保存干净、正确的 `tests/reference.xlsx`；
3. 从 reference 克隆 input，再应用确定性 mutation；
4. 将 input 同步到 `environment/input.xlsx`，将正确解同步到 `solution/reference.xlsx`；
5. 生成 `instruction.md`、`task.toml`、Dockerfile、Oracle `solve.sh`、`tests/test.sh`、verifier 和 manifest；
6. 在 `dataset_manifest.json` 汇总母本、公式数、修改量、原始 case 和弱点标签。

例如 [`SpreadsheetEval/debugging-03-coal-india/`](SpreadsheetEval/debugging-03-coal-india/) 包含：

```text
instruction.md
task.toml
environment/
  Dockerfile
  input.xlsx
solution/
  reference.xlsx
  solve.sh
tests/
  input.xlsx
  reference.xlsx
  manifest.json
  test.sh
  verifier.py
```

Oracle 的 `reference.xlsx` 是上述程序从真实母本归一化并构造出来的真实正确解，不是手工伪造答案。Oracle 可以按题目允许的方式直接复制 reference，生成逻辑见 [`solve.sh`](SpreadsheetEval/debugging-03-coal-india/solution/solve.sh)。

## 7. 第五步：严格 verifier 与防投机测试

[`spreadsheet_eval/verifier.py`](spreadsheet_eval/verifier.py) 的判定顺序为：

1. 没有 `/workspace/output.xlsx`：0 分；
2. sheet 名称、顺序、可见状态、尺寸、merged ranges、freeze panes 任一变化：0 分；
3. 原始 cell map 的修改集合不严格等于 manifest ground truth：0 分，同时输出 missing/extra；
4. 对 candidate/reference 都执行 LibreOffice headless 重算；
5. 数值四舍五入到两位、日期转为 `YYYY-MM-DD` 后比较 required cells；
6. 所有 required cell 值完全正确才得到 1，否则 0；没有部分分。

这里专门加入了两个负例：

- 原样提交 input：缺少全部 required edits，reward = 0；
- 提交正确 reference 后额外修改 `Model Inputs!A1`：即使所有目标正确，也因多改 1 cell 得 0。

负例结果见 [`reports/verifier-negative-tests.md`](reports/verifier-negative-tests.md)。结构、数值归一化、精确修改集合、Oracle payload 与 provenance 均由 8 个自动测试覆盖，见 [`tests/`](tests/)。

## 8. 迭代过程与迭代后的最终指标

| 阶段 | 做了什么 | 指标/发现 | 下一步 |
|---|---|---|---|
| 原始证据阶段 | 分析 97/97 条 SpreadsheetBench V2 Template 轨迹 | 7/97 通过；63 zero coverage、27 incomplete、27 over-editing | 用这些 bad pattern 定义算子和题目形态 |
| 数据集初版 | 5 个真实母本生成 5 Financial + 5 Debugging | 10 题、748 个精确目标、2-22 sheets、321-3,865 formulas | 检查 Harbor 布局、确定性和 provenance |
| Verifier 加固 | 加入结构保护、严格 changed-set、LibreOffice 重算、两位小数和日期归一化 | unchanged input = 0；正确解 + 1 extra = 0；8 tests passed | 运行 Oracle，排除错误题和 verifier 漏洞 |
| Oracle 终验 | Harbor 对全部 reference 运行 verifier | **10/10 = 1.000，0 exceptions** | 全量运行指定模型 |
| DeepSeek 全量评测 | `deepseek-chat` + Terminus-2，保留所有模型/终端/tool 轨迹 | **0/10 = 0.000，0 exceptions，0 retries** | 逐 case 阅读模型行为与候选工作簿 |
| 最终重放 | 用加固后的 verifier 对 10 个已保存 candidate 独立重放 | **仍为 0/10**；不是依赖运行时偶然错误 | 冻结数据集、轨迹、报告与语义哈希 |

最终汇总指标：

| 评测 | Tasks | Pass@1 | Exceptions | 结论 |
|---|---:|---:|---:|---|
| Harbor Oracle | 10 | **1.000** | 0 | 所有题目均有可达的确定正确解 |
| DeepSeek `deepseek-chat` | 10 | **0.000** | 0 | 达到 PDF 要求 ≤ 0.2 |
| 最终候选重放 | 10 | **0.000** | 0 | 加固 verifier 后结果保持一致 |

DeepSeek 全量运行耗时 **64 分 55 秒**，共使用 16,684,511 input tokens，其中 16,148,224 cached tokens，222,177 output tokens，记录成本 **$0.182505**。请求 endpoint 为 `deepseek-chat`；10 条 ATIF 轨迹中服务端返回的 model name 均为 `deepseek-v4-flash`，这里如实保留而没有改写。

最终 10 题合计：**105 个 required cell 未修改，98 个正确 cell 被多改**。7/10 case 有 missing，6/10 有 extra，3/10 同时有 missing 和 extra。

## 9. 模型实测逐题分数表

| Task | Required | Missing | Extra | Steps / Tool calls | Reward | 完整证据 |
|---|---:|---:|---:|---:|---:|---|
| debugging-01-manufacturing-plan | 26 | 0 | 14 | 34 / 36 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/debugging-01-manufacturing-plan/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/debugging-01-manufacturing-plan/verifier.json) |
| debugging-02-commercial-real-estate | 24 | 0 | 10 | 15 / 15 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/debugging-02-commercial-real-estate/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/debugging-02-commercial-real-estate/verifier.json) |
| debugging-03-coal-india | 24 | 1 | 0 | 49 / 60 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/debugging-03-coal-india/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/debugging-03-coal-india/verifier.json) |
| debugging-04-financial-projection | 32 | 7 | 49 | 67 / 72 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/debugging-04-financial-projection/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/debugging-04-financial-projection/verifier.json) |
| debugging-05-project-finance | 32 | 7 | 0 | 51 / 82 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/debugging-05-project-finance/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/debugging-05-project-finance/verifier.json) |
| financial-01-manufacturing-plan | 140 | 22 | 2 | 29 / 27 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/financial-01-manufacturing-plan/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/financial-01-manufacturing-plan/verifier.json) |
| financial-02-commercial-real-estate | 60 | 0 | 1 | 16 / 17 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/financial-02-commercial-real-estate/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/financial-02-commercial-real-estate/verifier.json) |
| financial-03-coal-india | 130 | 53 | 0 | 33 / 32 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/financial-03-coal-india/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/financial-03-coal-india/verifier.json) |
| financial-04-financial-projection | 140 | 3 | 22 | 68 / 101 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/financial-04-financial-projection/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/financial-04-financial-projection/verifier.json) |
| financial-05-project-finance | 140 | 12 | 0 | 34 / 33 | 0 | [trajectory](evaluation_artifacts/real-deepseek-full/financial-05-project-finance/trajectory.json) / [verifier](evaluation_artifacts/real-deepseek-full/financial-05-project-finance/verifier.json) |

机器可读汇总与逐 cell delta 分别位于 [`aggregate-result.json`](evaluation_artifacts/real-deepseek-full/aggregate-result.json) 和 [`reports/real-deepseek-full-case-analysis.json`](reports/real-deepseek-full-case-analysis.json)。

## 10. 具体失败 case 分析

### Case A：最强 near-miss，60 个目标全对但多改 1 个 cell

`financial-02-commercial-real-estate` 要求恢复 60 个公式。DeepSeek 找全了 60/60，但基于相邻 pattern 又填写了本来应保持不变的 `Model!D72`。结果为 missing = 0、extra = 1、reward = 0。

这说明“公式看起来合理”和“OJ exact match 正确”不是一回事，也直接验证了 PDF 中“多改、少改都判 0”的要求。证据见该 case 的 [完整 trajectory](evaluation_artifacts/real-deepseek-full/financial-02-commercial-real-estate/trajectory.json)、[候选 output.xlsx](evaluation_artifacts/real-deepseek-full/financial-02-commercial-real-estate/output.xlsx) 和 [verifier delta](evaluation_artifacts/real-deepseek-full/financial-02-commercial-real-estate/verifier.json)。

### Case B：重算无报错，仍漏掉稀疏语义错误

`debugging-03-coal-india` 中，模型执行了 49 steps、60 次 tool calls，并用 wrapper pattern 扫描和 LibreOffice 重算确认“没有错误”。但它仍漏掉 `P&L!K59`：正确公式 `=J59` 被 `reference_drift` 注入为 `=J60`。两者都能正常计算，因此 `#REF!`/错误字符串扫描完全无效。

最终 missing = 1、extra = 0、reward = 0。注入真值见 [manifest](SpreadsheetEval/debugging-03-coal-india/tests/manifest.json)，模型过程见 [trajectory](evaluation_artifacts/real-deepseek-full/debugging-03-coal-india/trajectory.json)，最终差异见 [verifier](evaluation_artifacts/real-deepseek-full/debugging-03-coal-india/verifier.json)。

### Case C：22-sheet 上下文导致 precision/recall 同时失控

`debugging-04-financial-projection` 的母本包含 22 个 sheet 和 3,865 个真实公式。模型把两组 sales forecast 行判断为整体错误，额外改写了大量月度 cell；与此同时，三个 Income Statement 变体中的 7 个真实 fault 没有修复。

最终 required = 32、missing = 7、extra = 49、reward = 0。该轨迹共 67 steps、72 tool calls，清楚触发了原始评测的 `context-bloat + over-editing + incomplete-target-coverage + precision-recall-tradeoff`。完整人工分析见 [`reports/model-trajectory-findings.md`](reports/model-trajectory-findings.md)，cell 列表见 [`reports/real-deepseek-full-case-analysis.md`](reports/real-deepseek-full-case-analysis.md)。

### Case D：业务合理性检查反而促成 over-editing

`debugging-01-manufacturing-plan` 实际找全了 26 个 fault，但又根据 Balance Sheet 和 Model Inputs 的业务 pattern 修改了 14 个正确 cell。现金能对平、贷款余额归零只说明结果“业务上看起来合理”，不能证明 changed-set 精确。

最终 missing = 0、extra = 14、reward = 0。模型甚至在 final message 中判断 “No further edits are needed”，属于典型 false-completion confidence。证据见 [trajectory](evaluation_artifacts/real-deepseek-full/debugging-01-manufacturing-plan/trajectory.json) 和 [verifier](evaluation_artifacts/real-deepseek-full/debugging-01-manufacturing-plan/verifier.json)。

10 个 case 的逐条人工阅读结论见 [`reports/model-trajectory-findings.md`](reports/model-trajectory-findings.md)；带 token、成本、最终消息和完整 missing/extra cell 的报告见 [`reports/real-deepseek-full-case-analysis.md`](reports/real-deepseek-full-case-analysis.md)。

## 11. 如何复现生成、Oracle 和模型评测

### 11.1 环境与数据集生成

要求：Python 3.11、Docker、Harbor，以及支持 LibreOffice 的运行环境。

```bash
python3.11 -m venv .venv311
.venv311/bin/python -m pip install -e '.[test]'

docker build -f SWE-agent/spreadsheet.Dockerfile \
  -t spreadsheetbench-v2 SWE-agent/docker-context

bash scripts/fetch_real_workbooks.sh
.venv311/bin/python scripts/generate_real_spreadsheet_eval.py
.venv311/bin/python -m pytest -q tests
```

### 11.2 Harbor Oracle

```bash
harbor run -p SpreadsheetEval -a oracle --n-concurrent 1 \
  --job-name real-oracle -o jobs -y
```

验收要求是 10 个 task reward 全部为 1.0；本次冻结结果见 [`reports/real-oracle-final-result.json`](reports/real-oracle-final-result.json)。

### 11.3 DeepSeek 全量评测与定时监控

`DEEPSEEK_API_KEY` 可以通过环境变量传入，也可以在 macOS Keychain 中以 service `spreadsheetbench-v2-deepseek` 保存。密钥不会写入仓库或轨迹。

```bash
bash scripts/run_construction_eval.sh real-deepseek-full
bash scripts/monitor_construction_eval.sh real-deepseek-full 60
python scripts/analyze_harbor_results.py real-deepseek-full
python scripts/export_evaluation_artifacts.py real-deepseek-full
python scripts/replay_final_verifier.py real-deepseek-full
```

监控脚本每 60 秒记录完成数、错误数、轨迹数、输出数和磁盘空间；本次记录见 [`evaluation_artifacts/real-deepseek-full/monitor.csv`](evaluation_artifacts/real-deepseek-full/monitor.csv)。导出器会拒绝未完成或含异常的 job，避免把半成品当最终结果。

## 12. 完整轨迹保存格式

每道题在 [`evaluation_artifacts/real-deepseek-full/`](evaluation_artifacts/real-deepseek-full/) 下都保存：

- `trajectory.json`：完整 ATIF 模型 step、tool call、observation；
- `terminal-recording.cast`：可回放的 asciinema 终端录像；
- `terminal-pane.txt`：终端完整文本；
- `output.xlsx`：模型提交的真实候选工作簿；
- `trial-config.json`、`trial-result.json`、`trial.log`：运行参数、结果与日志；
- `verifier.json`、`reward.txt`：精确 missing/extra/value error 与最终 reward；
- `artifact-manifest.json`：该 case 的证据文件索引。

聚合层还包括 `aggregate-result.json`、`final-verifier-replay.json`、`monitor.csv` 和 `run.log`。因此后续可以从模型文本、工具轨迹、终端操作、候选 Excel 到最终 cell delta 做完整回溯。

## 13. Codebase 导航

| 目录/文件 | 作用 |
|---|---|
| [`SpreadsheetEval/`](SpreadsheetEval/) | 10 个可直接运行的 Harbor task |
| [`SpreadsheetEval/dataset_manifest.json`](SpreadsheetEval/dataset_manifest.json) | 10 题类别、母本、公式数、修改量和弱点总表 |
| [`spreadsheet_eval/mutation_operators.py`](spreadsheet_eval/mutation_operators.py) | 跨表选点、blank/sign flip/offset/reference drift 算子 |
| [`spreadsheet_eval/real_generator.py`](spreadsheet_eval/real_generator.py) | 母本归一化、任务生成、manifest、Oracle 和 Harbor 文件构造 |
| [`spreadsheet_eval/verifier.py`](spreadsheet_eval/verifier.py) | 结构保护、修改集合、LibreOffice 重算和值比较 |
| [`spreadsheet_eval/provenance.py`](spreadsheet_eval/provenance.py) | 语义 digest 与原始 case 弱点证据校验 |
| [`scripts/`](scripts/) | 下载、生成、运行、监控、分析、导出、重放入口 |
| [`tests/`](tests/) | 8 个数据集、算子、provenance、verifier 自动测试 |
| [`third_party/real_workbooks/SOURCES.md`](third_party/real_workbooks/SOURCES.md) | 真实 Excel 来源、commit、SHA-256、许可证和筛选记录 |
| [`reports/final_summary.md`](reports/final_summary.md) | 最终验收指标摘要 |
| [`reports/original_template_97_cases.md`](reports/original_template_97_cases.md) | 原始 97 case 的逐案弱点证据 |
| [`reports/model-trajectory-findings.md`](reports/model-trajectory-findings.md) | 新构造 10 题的逐轨迹人工分析 |
| [`reports/real-deepseek-full-case-analysis.md`](reports/real-deepseek-full-case-analysis.md) | 每题 token、成本、最终消息和 cell-level verifier delta |
| [`evaluation_artifacts/real-deepseek-full/`](evaluation_artifacts/real-deepseek-full/) | 全量 DeepSeek 轨迹、录像、候选 Excel、日志和 verifier 证据 |

更细的设计说明见 [`README_CONSTRUCTION.md`](README_CONSTRUCTION.md)；上游 SpreadsheetBench V2 原始使用说明保留在 [`README_UPSTREAM.md`](README_UPSTREAM.md)；中文瑞士风调研汇报见 [`reports/spreadsheetbench-v2-overview.html`](reports/spreadsheetbench-v2-overview.html)。
