# Git Commit 指引導航

> 此檔案已拆分為兩個專門檔案，以優化 token 使用量。

## 📚 文件結構

### 🔄 [git-commit-workflow.md](git-commit-workflow.md)
**互動式工作流程** - 當你需要整理多個不相關的變更時使用

**Token 消耗：~800 tokens**

包含內容：
- ⚠️ 強制互動式 7 步驟流程
- 變更分類策略
- 處理策略與範例場景
- Git 操作安全原則
- 敏感檔案警告清單

**適用情境：**
- 工作目錄有多個不相關的變更需要分批提交
- 需要將混雜的變更邏輯分組
- 需要逐步審查每個 commit

---

### 📐 [git-commit-format.md](git-commit-format.md)
**Commit 訊息格式規範** - 查閱 Conventional Commits 規範時使用

**Token 消耗：~2,000 tokens**

包含內容：
- Conventional Commits 完整格式規範
- Type、Scope、Subject、Body、Footer 詳細說明
- Flutter 專案範例
- Laravel 專案範例
- Breaking Changes 處理方式

**適用情境：**
- 需要查閱 Conventional Commits 格式
- 不確定應該使用哪個 Type
- 需要參考範例撰寫 commit message
- 處理 Breaking Changes

---

## 🎯 使用建議

### 一般情況（推薦）
只載入 **workflow.md**：
- 適合日常使用
- 省 Token（~800 vs ~5,000）
- 包含完整互動式流程

### 需要查閱規範時
額外載入 **format.md**：
- 當不確定 Type 定義時
- 當需要參考範例時
- 當處理 Breaking Changes 時

### 首次使用或訓練新成員
同時載入兩個檔案：
- 完整了解規範與流程
- 建立標準化的 commit 習慣

---

## 💡 快速參考

### Commit Message 格式
```
<type>(<scope>): <subject>

<body>

<footer>
```

### 常用 Type
- `feat` - 新功能
- `fix` - 錯誤修復
- `docs` - 文件更新
- `refactor` - 重構
- `perf` - 效能改善
- `test` - 測試
- `chore` - 建構/工具

### 互動式流程（7 步驟）
1. 分析變更（`git status`, `git diff`）
2. 識別群組（feat, fix, docs, etc.）
3. **提出計畫並等待批准** ⚠️
4. 分步執行（一次一個群組）
5. 精準暫存（`git add`）
6. 撰寫訊息（Conventional Commits）
7. 展示進度並重複

---

## 📊 Token 優化效果

| 使用方式 | Token 消耗 | 節省比例 |
|---------|-----------|---------|
| 舊版（完整檔案） | ~5,000 | - |
| 只用 workflow | ~800 | 84% ⬇️ |
| 只用 format | ~2,000 | 60% ⬇️ |
| 兩個都用 | ~2,800 | 44% ⬇️ |

---

## 🔗 相關文件

- **Laradock 環境設定**：參考 `~/.claude/CLAUDE.md`
- **Security Review**：參考 `security-review-*.md`
- **Laravel Expert**：參考 `laravel-expert.md`
- **Flutter Expert**：參考 `flutter-expert.md`
