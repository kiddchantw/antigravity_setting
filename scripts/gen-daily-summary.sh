#!/bin/bash

# 腳本名稱: gen-daily-summary.sh
# 用途: 收集指定路徑今日的 Git 變更資料，生成每日工作總結的 Markdown 草稿
# 使用方式: ./gen-daily-summary.sh [路徑]

# 1. 設定變數
TARGET_PATH="${1:-.}"
CURRENT_DATE=$(date +%Y-%m-%d)
OUTPUT_FILE="工作總結-${CURRENT_DATE}.md"

# 2. 檢查 Git 環境
if ! command -v git &> /dev/null; then
    echo "❌ 錯誤: 未找到 git 指令"
    exit 1
fi

# 3. 收集資料
echo "🔍 正在分析 ${TARGET_PATH} 的變更資料..."

# 3.1 獲取今日 Commit (從 00:00 開始)
COMMITS_LOG=$(git log --since="midnight" --pretty=format:"- %h %s (%an)" --stat -- "${TARGET_PATH}")

# 3.2 獲取當前工作區狀態 (Staged + Unstaged)
GIT_STATUS=$(git status --short "${TARGET_PATH}")

# 3.3 獲取未提交的 Diff 統計 (Working Directory)
DIFF_UNSTAGED=$(git diff --stat "${TARGET_PATH}")

# 3.4 獲取已暫存的 Diff 統計 (Staged)
DIFF_STAGED=$(git diff --cached --stat "${TARGET_PATH}")

# 4. 寫入 Markdown 檔案
cat <<EOF > "${OUTPUT_FILE}"
<!-- 
🤖 AI 指令區 (Prompt)
================================================================================
請扮演技術專案經理，閱讀下方的【原始變更資料】，
針對路徑 \`${TARGET_PATH}\` 撰寫一份今日的工作總結。

輸出請嚴格遵循以下 Markdown 格式（使用繁體中文）：

# 📅 工作總結 - ${CURRENT_DATE}

## 🚀 執行摘要 (Executive Summary)
*一句話說明今天在這個模組的主要產出（例如：完成購物車 API 串接）。*

## ⚡️ 主要變更 (Key Changes)
*條列式說明功能增減或 Bug 修復，請根據 Commit 訊息與檔案變更推斷：*
- **[類別]** (Feature/Fix/Refactor): 變更描述
  - 📄 涉及檔案: \`檔案路徑\`

## 🔧 技術細節 (Technical Details)
*簡述關鍵的實作邏輯、架構調整或遇到的技術挑戰與解決方案。*

## 📌 狀態更新
- [ ] 是否有更新文件？
- [ ] 是否有引入新的相依性？

## ⏭️ 下一步 (Next Steps)
*根據今日進度，列出明天的待辦事項。*

================================================================================
-->

# 📊 原始變更資料 (Raw Context)

以下是系統自動收集的變更紀錄，供 AI 參考撰寫使用。

## 1. 🕒 今日提交紀錄 (Commits since midnight)
${COMMITS_LOG:-*(今日尚無提交)*]

## 2. 📝 目前檔案狀態 (git status)
\`\`\`text
${GIT_STATUS:-*(無未提交變更)*}
\`\`\`

## 3. 📉 變更統計 (Diff Stats)

### 尚未暫存 (Unstaged):
\`\`\`text
${DIFF_UNSTAGED:-*(無)*}
\`\`\`

### 已暫存 (Staged):
\`\`\`text
${DIFF_STAGED:-*(無)*}
\`\`\`

EOF

echo "✅ 已生成總結草稿：${OUTPUT_FILE}"
echo "👉 建議操作：開啟該檔案，全選內容或使用 Composer/Chat 功能，讓 AI 根據開頭的指令生成內容。"

