# Git Commit 訊息規範（繁體中文）

> 遵循 Conventional Commits 規範，使用繁體中文撰寫 commit 訊息。

## 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Type 定義（必要）

- `feat`: 新增/修改功能
- `fix`: 修補 bug
- `docs`: 文件變更
- `style`: 格式調整（不影響程式碼運行）
- `refactor`: 重構
- `perf`: 效能改善
- `test`: 測試相關
- `chore`: 建構或工具變動
- `revert`: 撤銷先前的 commit

## Scope（選用）

影響範圍，例如：模組名稱、功能區域、檔案名稱。範圍廣泛或難以定義時可省略。

常見 scope：`auth`, `api`, `ui`, `state`, `config`, `l10n`

## Subject（必要）

- 不超過 50 個字元
- 使用繁體中文
- 結尾不加句號
- 使用祈使句或陳述句

## Body（選用）

- 每行不超過 72 個字元
- 使用繁體中文
- 說明變更的項目、原因與影響
- 變更簡單明確時可省略

## Footer（選用）

- **任務編號**：`Refs: #123` 或 `Closes: #456`
- **Breaking Changes**：以 `BREAKING CHANGE:` 開頭，說明變動內容、原因及遷移方法

## 範例

### 簡單變更
```
docs(readme): 更新安裝說明
```

### 功能新增
```
feat(auth): 新增 Google OAuth 登入功能

- 整合 Google OAuth 2.0 認證流程
- 新增使用者資料同步機制

Refs: #234
```

### 重大變更
```
feat(api): 更新 API 回應格式為 RESTful 標準

- 統一所有 API 端點的回應結構
- 改用標準 HTTP 狀態碼

BREAKING CHANGE: API 回應格式已變更。
舊格式：{ data: [], status: "success" }
新格式：{ data: [], meta: { status: 200 } }

遷移方法：請更新前端 API 串接邏輯，參考新的 API 文件。

Refs: #789
```

## 重要提醒

### Commit 訊息
- Subject 繁體中文，簡潔明瞭
- 優先考慮可讀性和實用性
- Breaking Changes 務必明確標示
- Scope 若不明確可省略，不要強加

### Git 操作
- **永遠先檢查 git status**：了解當前狀態
- **只處理當前資料夾**：執行 git 指令時，只整理當前執行資料夾內的檔案異動，不要跳出該資料夾處理其他路徑的變更
- **新增檔案需明確確認**：避免意外 commit 敏感檔案
- **敏感檔案警告清單**：
  - `.env*`, `*.local`, `*.secret`
  - `credentials.json`, `secrets.json`, `config.json`
  - `*_rsa`, `*.pem`, `*.key`, `*.p12`
  - `node_modules/`, `.dart_tool/`, `.DS_Store`
  - `*.g.dart`, `*.freezed.dart` (generated files)
- **不要自動 push**：除非使用者明確要求

### 處理多個不相關的變更

當 `git status` 顯示多個不相關的變更時，應該分開提交：

#### 1. 識別變更類型
使用 `git diff <file>` 檢查每個檔案的變更內容，判斷是否相關：
```bash
git diff docs/INDEX-architecture.md
git diff lib/api/openapi_config.dart
```

#### 2. 分類變更
將變更分為不同類別：
- **當前功能相關**：與正在開發的功能直接相關
- **文檔更新**：文檔修正、格式調整
- **配置變更**：OpenAPI、依賴更新等
- **錯字修正**：純文字修正
- **意外變更**：不需要的編輯

#### 3. 處理策略

**A. 還原不需要的變更**
```bash
git restore <file1> <file2>
```

**B. 分別提交相關變更**
```bash
# 第一個 commit：當前功能
git add lib/services/new_service.dart lib/providers/new_provider.dart
git commit -m "feat(feature): 實作新功能"

# 第二個 commit：文檔更新
git add docs/INDEX-product.md
git commit -m "docs: 更新產品功能索引"

# 第三個 commit：錯字修正
git add docs/sessions/2025-11/21-session.md
git commit -m "docs: 修正錯字"
```

**C. 使用互動式暫存（進階）**
```bash
git add -p <file>  # 選擇性暫存檔案的部分變更
```

#### 4. 提交順序建議
1. 功能實作（feat/fix）
2. 重構（refactor）
3. 文檔更新（docs）
4. 配置變更（chore）
5. 錯字修正（docs）

#### 5. 範例場景

**場景：開發新功能時發現其他檔案有變更**
```bash
# 檢查狀態
git status

# 發現：
# - lib/services/new_service.dart (新功能)
# - docs/INDEX-product.md (簡化格式)
# - docs/sessions/old-session.md (錯字修正)

# 處理方式：
# 1. 先提交新功能
git add lib/services/new_service.dart
git commit -m "feat(api): 新增服務層"

# 2. 確認文檔簡化是否需要
git diff docs/INDEX-product.md
# 如果不需要：git restore docs/INDEX-product.md
# 如果需要：git add docs/INDEX-product.md && git commit -m "docs: 簡化產品索引格式"

# 3. 提交錯字修正
git add docs/sessions/old-session.md
git commit -m "docs: 修正 session 文件錯字"
```

## Flutter 專案特定注意事項

### 常見 Scope
- `auth`: 認證相關
- `api`: API 整合
- `ui`: UI 元件
- `state`: 狀態管理
- `l10n`: 國際化
- `deps`: 依賴項更新
- `config`: 配置變更

### 範例
```
feat(ui): 新增啤酒清單頁面

- 實作 BeerListPage widget
- 使用 Riverpod 管理狀態
- 支援下拉重新整理

Refs: #123
```

```
fix(api): 修正登入 API 錯誤處理

- 正確處理 401 未授權錯誤
- 改善錯誤訊息顯示

Closes: #456
```
