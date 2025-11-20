# .agent/workflows 目錄

此目錄包含 Antigravity AI 助手的自動化工作流程（Workflows）。這些工作流程定義了可重複執行的任務步驟，可以透過 Slash Commands 快速調用。

## 🚀 可用工作流程

### [建立session.md](建立session.md)
**指令**: `/建立session` 或 `/session-create`
**功能**: 建立一個新的開發 Session。
**執行內容**: 執行 `.agent/scripts/create-session.sh` 腳本。
**使用時機**: 開始一個新功能開發或修復任務時。

### [封存session.md](封存session.md)
**指令**: `/封存session` 或 `/session-archive`
**功能**: 封存目前的開發 Session。
**執行內容**: 執行 `.agent/scripts/archive-session.sh` 腳本。
**使用時機**: 完成當前任務，準備結束 Session 時。

### [更新changelog.md](更新changelog.md)
**指令**: `/更新changelog` 或 `/changelog-update`
**功能**: 更新專案的 Changelog。
**執行內容**: 執行 `.agent/scripts/update-changelog.sh` 腳本。
**使用時機**: 完成功能開發或發布新版本前。

## 📖 使用方式

在對話框中輸入 `/` 加上指令名稱即可執行。例如：

```
/建立session
```

AI 將會自動讀取對應的 workflow 文件並執行其中的步驟。

## 🛠️ 如何新增 Workflow

1. 在此目錄下建立一個新的 `.md` 檔案。
2. 使用 YAML Frontmatter 定義描述：
   ```markdown
   ---
   description: 您的工作流程描述
   ---
   ```
3. 定義步驟和命令：
   ```markdown
   1. 第一步說明
   // turbo (可選：自動執行)
   ```bash
   echo "Hello World"
   ```
   ```

## 🔗 相關資源

- **Instructions**: `../instructions/` - AI 行為準則和專業知識
- **專案腳本**: `../scripts/` - 實際執行的 Shell 腳本
