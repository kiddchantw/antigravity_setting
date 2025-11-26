# .agent Directory

## 前置作業 
> 
> 請確保本地專案中存在 `.agent` 資料夾。
> 
> - **位置**: 專案根目錄 (例如: `/Users/kiddchan/Desktop/laraDock/a126/.agent`)
> - **用途**: 存放 AI Agent 的配置、指令、工作流程和模板
> - **必要性**: Antigravity 會自動載入此目錄中的 `instructions/` 和 `workflows/`
> 
> **正確使用流程**：
> ```bash
> # 1. 先建立 .agent 資料夾
> mkdir -p .agent/{instructions,workflows,scripts,templates}
> 
> # 2. 然後 git clone 此專案
> git clone <repository-url>
> ```

本目錄包含跨 AI Agent 通用的配置、指令、工作流程和模板。

## 📂 目錄結構

```
.agent/
├── instructions/     # AI 行為準則與專業指令
├── workflows/        # 可執行的工作流程 (Slash Commands)
├── scripts/          # Shell 腳本工具
├── templates/        # 文檔模板
└── README.md         # 本文件
```

## 🤖 不同 AI Agent 使用指南

### Gemini (Antigravity) ✅ 原生支援

**自動載入**：
- `instructions/` 中的檔案會自動作為系統指令
- `workflows/` 可透過 slash commands 執行

**使用方式**：
```
# 引用指令
@[.agent/instructions/flutter-expert.md]

# 執行工作流程
/建立session
/封存session
/更新changelog
```

---

### Claude Code ✅ 完整支援

**手動引用**：
```
# 在對話中引用指令
@.agent/instructions/flutter-expert.md

# 執行腳本
Run: .agent/scripts/create-session.sh
```

**最佳實踐**：
- 在專案 `GEMINI.md` 中說明可用的 instructions
- 需要時手動引用相關指令檔案

---

### Cursor ⚠️ 需要配置

**設定方式**：

1. 在專案根目錄創建 `.cursorrules` 檔案：

```markdown
# AI Instructions

請遵循以下專業指令：

## Flutter 開發規範
@.agent/instructions/flutter-expert.md

## Git Commit 規範
@.agent/instructions/git-commit-tw.md

## 安全審查
@.agent/instructions/security-review.md

## 效能優化
@.agent/instructions/performance-review.md
```

2. Cursor 會在每次對話時自動載入這些指令

**執行腳本**：
```bash
# 在 Cursor 終端機中執行
./.agent/scripts/create-session.sh
```

---

### GitHub Copilot ⚠️ 有限支援

**使用方式**：
- 無法直接讀取 `.agent/` 結構
- 可透過註解引導：

```dart
// 請參考 .agent/instructions/flutter-expert.md 中的規範
// 使用 BLoC pattern 實作狀態管理
```

**建議**：
- 在程式碼中加入註解引用相關指令
- 手動執行 `.agent/scripts/` 中的腳本

---

### ChatGPT / GPT-5 (網頁版) ❌ 不支援

**替代方案**：
1. 手動複製 `.agent/instructions/` 中的內容到對話中
2. 在對話開始時貼上相關指令：

```
請遵循以下 Flutter 開發規範：
[貼上 flutter-expert.md 的內容]
```

---

## 📚 Instructions (指令檔案)

| 檔案 | 用途 | 適用情境 |
|------|------|---------|
| `flutter-expert.md` | Flutter 開發規範 | 開發 Flutter 功能時 |
| `git-commit-tw.md` | Git Commit 規範 | 提交程式碼時 |
| `security-review.md` | 安全審查指南 | 審查安全性問題時 |
| `performance-review.md` | 效能優化指南 | 優化效能時 |

**使用時機**：
- 開發新功能前，引用相關的 instruction
- 例如：開發 Flutter UI 時引用 `@flutter-expert`

---

## ⚡ Workflows (工作流程)

| Slash Command | 功能 | 說明 |
|--------------|------|------|
| `/建立session` | 建立開發 Session | 開始新功能開發時使用 |
| `/封存session` | 封存 Session | 完成功能開發後使用 |
| `/更新changelog` | 更新 Changelog | 準備發布新版本時使用 |
| `/init-docs` | 初始化文檔結構 | 新專案初始化時使用 |

**執行方式**：
- **Gemini**: 直接輸入 slash command（例如 `/建立session`）
- **其他 AI**: 手動執行對應的 script（例如 `.agent/scripts/create-session.sh`）

---

## 🛠️ Scripts (腳本工具)

| 腳本 | 功能 |
|------|------|
| `create-session.sh` | 建立新的開發 Session |
| `archive-session.sh` | 封存完成的 Session |
| `update-changelog.sh` | 更新專案 Changelog |
| `init-docs.sh` | 初始化文檔結構 |

**執行方式**：
```bash
# 從專案根目錄執行
./.agent/scripts/create-session.sh

# 或從子專案執行
../.agent/scripts/create-session.sh
```

---

## 📄 Templates (模板)

| 模板 | 用途 |
|------|------|
| `session.md` | Session 文檔模板 |
| `GUIDE.md` | Session 使用指南 |
| `INDEX-product.md` | 產品功能索引 |
| `INDEX-architecture.md` | 架構決策索引 |
| `INDEX-decisions.md` | 技術決策索引 |
| `GEMINI.md` | 專案 AI 配置模板 |

**使用方式**：
- 執行 `/init-docs` 或 `init-docs.sh` 會自動複製這些模板到專案中

---

## 🎯 最佳實踐

### 1. 專案初始化
```bash
# 執行文檔初始化
./.agent/scripts/init-docs.sh .

# 或使用 workflow (Gemini)
/init-docs
```

### 2. 開發新功能
```bash
# 1. 建立 Session
/建立session  # Gemini
# 或
./.agent/scripts/create-session.sh  # 其他 AI

# 2. 引用相關指令
@flutter-expert  # 如果是 Flutter 開發

# 3. 開發...

# 4. 完成後封存
/封存session  # Gemini
# 或
./.agent/scripts/archive-session.sh  # 其他 AI
```

### 3. 發布新版本
```bash
# 更新 Changelog
/更新changelog  # Gemini
# 或
./.agent/scripts/update-changelog.sh  # 其他 AI
```

---

## 🔄 跨專案共用

本 `.agent/` 目錄位於 workspace 根目錄，可被多個子專案共用：

```
beer/
├── .agent/              # 共用配置
├── HoldYourBeer/        # Laravel 專案
│   └── GEMINI.md        # 引用 ../.agent/
└── HoldYourBeer-Flutter/  # Flutter 專案
    └── GEMINI.md        # 引用 ../.agent/
```

**在子專案中使用**：
```markdown
# HoldYourBeer/GEMINI.md
## 🤖 AI Agent Configuration

### 📚 Instructions
- **Flutter 開發**: @[../.agent/instructions/flutter-expert.md]
- **Git Commits**: @[../.agent/instructions/git-commit-tw.md]
```

---

## 📝 貢獻指南

### 新增 Instruction
1. 在 `instructions/` 中創建新的 `.md` 檔案
2. 使用清晰的標題和結構
3. 在專案 `GEMINI.md` 中加入引用

### 新增 Workflow
1. 在 `workflows/` 中創建新的 `.md` 檔案
2. 使用 YAML frontmatter 格式：
```markdown
---
description: 工作流程簡短描述
---

1. 步驟一
2. 步驟二
```

### 新增 Script
1. 在 `scripts/` 中創建新的 `.sh` 檔案
2. 加入執行權限：`chmod +x .agent/scripts/your-script.sh`
3. 在 `workflows/` 中創建對應的 workflow

---

## ❓ 常見問題

**Q: 為什麼選擇 `.agent/` 這個名稱？**
A: 以 `.` 開頭的目錄在 Unix 系統中是隱藏目錄，不會干擾專案主要結構，且 `agent` 清楚表明這是 AI Agent 的配置。

**Q: 可以在不同專案間共用嗎？**
A: 可以！將 `.agent/` 放在 workspace 根目錄，所有子專案都可以引用。

**Q: 如果 AI 不支援怎麼辦？**
A: 手動複製相關指令內容到對話中，或在程式碼註解中引用相關規範。

**Q: 需要加入版本控制嗎？**
A: 建議加入！這樣團隊成員都能使用相同的 AI 配置。

---

**Last Updated**: 2025-11-20
