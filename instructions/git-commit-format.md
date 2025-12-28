# Git Commit 訊息格式規範

> 遵循 Conventional Commits 規範，使用繁體中文撰寫 commit 訊息。

## 📐 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

---

## 🏷️ Type 定義（必要）

| Type | 說明 | 使用時機 |
|------|------|---------|
| `feat` | 新增/修改功能 | 新功能開發、功能增強 |
| `fix` | 修補 bug | 錯誤修復、問題解決 |
| `docs` | 文件變更 | README、註解、文檔更新 |
| `style` | 格式調整 | 不影響程式碼運行的格式變更 |
| `refactor` | 重構 | 既不修 bug 也不加功能的程式碼改善 |
| `perf` | 效能改善 | 提升效能的程式碼變更 |
| `test` | 測試相關 | 新增或修改測試 |
| `chore` | 建構或工具變動 | 依賴更新、建構腳本、配置變更 |
| `revert` | 撤銷先前的 commit | 回退先前的變更 |

---

## 🎯 Scope（選用）

影響範圍，例如：模組名稱、功能區域、檔案名稱。

### 通用 Scope
- `auth` - 認證相關
- `api` - API 整合
- `ui` - UI 元件
- `state` - 狀態管理
- `config` - 配置變更
- `deps` - 依賴項更新

### Flutter 專案常見 Scope
- `l10n` - 國際化
- `routing` - 路由
- `widget` - Widget 元件
- `provider` - Provider/Riverpod
- `model` - 資料模型

### Laravel 專案常見 Scope
- `migration` - 資料庫遷移
- `model` - Eloquent 模型
- `controller` - 控制器
- `middleware` - 中介層
- `validation` - 驗證規則

**注意**：範圍廣泛或難以定義時可省略，不要強加不明確的 scope。

---

## 📝 Subject（必要）

### 規則
- 不超過 50 個字元
- 使用繁體中文
- 結尾不加句號
- 使用祈使句或陳述句
- 簡潔明瞭，描述「做了什麼」

### 範例
✅ **好的 subject**
```
feat(auth): 新增 Google OAuth 登入功能
fix(api): 修正登入逾時處理
docs: 更新安裝說明
refactor(ui): 簡化登入表單邏輯
```

❌ **不好的 subject**
```
feat(auth): 新增了一個很酷的 Google OAuth 登入功能。
fix: 修 bug
docs: update
refactor: 改code
```

---

## 📄 Body（選用）

### 規則
- 每行不超過 72 個字元
- 使用繁體中文
- 說明變更的項目、原因與影響
- 變更簡單明確時可省略

### 何時需要 Body
- 變更涉及多個檔案或功能
- 需要解釋「為什麼」做這個變更
- 有重要的實作細節需要記錄

### 範例
```
feat(auth): 新增 Google OAuth 登入功能

- 整合 Google OAuth 2.0 認證流程
- 新增使用者資料同步機制
- 支援自動建立新使用者帳號
```

---

## 🔗 Footer（選用）

### 任務編號
關聯 Issue 或 Task：

```
Refs: #123
Closes: #456
Fixes: #789
```

### Breaking Changes
當有不相容的 API 變更時，必須使用 `BREAKING CHANGE:` 標記：

```
BREAKING CHANGE: API 回應格式已變更。
舊格式：{ data: [], status: "success" }
新格式：{ data: [], meta: { status: 200 } }

遷移方法：請更新前端 API 串接邏輯，參考新的 API 文件。
```

---

## 📋 完整範例

### 範例 1：簡單變更
```
docs(readme): 更新安裝說明
```

### 範例 2：功能新增
```
feat(auth): 新增 Google OAuth 登入功能

- 整合 Google OAuth 2.0 認證流程
- 新增使用者資料同步機制
- 支援自動建立新使用者帳號

Refs: #234
```

### 範例 3：錯誤修復
```
fix(api): 修正登入 API 錯誤處理

- 正確處理 401 未授權錯誤
- 改善錯誤訊息顯示
- 新增錯誤日誌記錄

Closes: #456
```

### 範例 4：效能改善
```
perf(query): 優化使用者查詢效能

- 新增資料庫索引至 users.email
- 使用 eager loading 減少 N+1 查詢
- 查詢速度提升 60%

Refs: #567
```

### 範例 5：重大變更
```
feat(api): 更新 API 回應格式為 RESTful 標準

- 統一所有 API 端點的回應結構
- 改用標準 HTTP 狀態碼
- 新增分頁 meta 資訊

BREAKING CHANGE: API 回應格式已變更。
舊格式：{ data: [], status: "success" }
新格式：{ data: [], meta: { status: 200 } }

遷移方法：請更新前端 API 串接邏輯，參考新的 API 文件。

Refs: #789
```

---

## 🎨 Flutter 專案範例

### 新增 UI 元件
```
feat(ui): 新增啤酒清單頁面

- 實作 BeerListPage widget
- 使用 Riverpod 管理狀態
- 支援下拉重新整理

Refs: #123
```

### API 整合
```
feat(api): 整合 OpenAPI 自動產生的 API client

- 使用 openapi-generator 產生 API client
- 新增 ApiClient 服務層
- 實作錯誤處理機制

Refs: #234
```

### 國際化
```
feat(l10n): 新增英文語系支援

- 新增 app_en.arb 翻譯檔
- 更新所有 UI 文字使用 AppLocalizations
- 支援動態切換語系

Refs: #345
```

---

## 🏗️ Laravel 專案範例

### 資料庫遷移
```
feat(migration): 新增 beers 資料表

- 建立 beers 資料表結構
- 新增品牌、類型、ABV 欄位
- 設定外鍵關聯至 users 表

Refs: #123
```

### API 端點
```
feat(api): 新增啤酒清單 API 端點

- 實作 BeerController@index
- 支援分頁、排序、篩選
- 新增 BeerResource 格式化回應

Refs: #234
```

### 驗證規則
```
feat(validation): 新增啤酒建立表單驗證

- 實作 StoreBeerRequest
- 驗證必填欄位與格式
- 新增自訂錯誤訊息

Refs: #345
```

---

## ✅ 重要提醒

### Commit 訊息撰寫
- ✅ Subject 使用繁體中文，簡潔明瞭
- ✅ 優先考慮可讀性和實用性
- ✅ Breaking Changes 務必明確標示
- ✅ Scope 若不明確可省略，不要強加
- ✅ 每個 commit 應該是一個邏輯完整的變更單位

### Type 選擇原則
- `feat` vs `fix`：問自己「這是新增功能還是修復問題？」
- `refactor` vs `perf`：問自己「這是改善程式碼結構還是提升效能？」
- `docs` vs `chore`：問自己「這是文檔更新還是工具/配置變更？」

### 常見錯誤
❌ 一個 commit 包含多個不相關的變更
❌ Subject 太長或太模糊
❌ 使用中英文混雜的 subject
❌ 濫用 scope（如：`feat(fix): ...`）
❌ Breaking Changes 沒有明確標示

---

## 📚 參考資源

- [Conventional Commits 規範](https://www.conventionalcommits.org/)
- [Angular Commit Message Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)

---

## 🔄 相關文件

- **互動式工作流程**：參考 `git-commit-workflow.md`
- **多變更處理策略**：參考 `git-commit-workflow.md`
