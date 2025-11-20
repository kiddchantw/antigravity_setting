# .agent/instructions 目錄

此目錄包含 Antigravity AI 助手的專業指示和最佳實踐指南。這些指示定義了 AI 在處理特定任務時應遵循的原則、標準和方法。

## 📚 可用指示

### [flutter-expert.md](flutter-expert.md)
Flutter 開發專家指示，涵蓋：
- Dart 語言和 null safety
- Widget 架構和組合
- 狀態管理（Riverpod）
- UI/UX 實作
- 效能優化
- 平台整合
- 測試策略

**使用時機**: 處理任何 Flutter/Dart 程式碼時

### [git-commit-tw.md](git-commit-tw.md)
Git commit 訊息規範（繁體中文），遵循 Conventional Commits：
- Commit 訊息格式
- Type 和 scope 定義
- 範例和最佳實踐
- Flutter 專案特定注意事項

**使用時機**: 撰寫 git commit 訊息時

### [security-review.md](security-review.md)
Flutter 安全審查指示，包含：
- 輸入驗證與資料清理
- 資料儲存與保護
- 認證與授權
- 網路安全
- 權限處理
- 常見漏洞檢查

**使用時機**: 審查程式碼安全性或實作安全功能時

### [performance-review.md](performance-review.md)
Flutter 效能優化指示，涵蓋：
- Widget 優化
- 重建優化
- 列表與滾動效能
- 圖片優化
- 記憶體管理
- 分析工具使用

**使用時機**: 優化應用程式效能或診斷效能問題時

## 🔄 與 Workflows 的關係

### Instructions（指示）
- **目的**: 定義「如何思考」和「專業知識」
- **內容**: 原則、標準、最佳實踐
- **影響**: AI 的決策過程和程式碼品質

### Workflows（工作流程）
- **目的**: 定義「做什麼」和「怎麼做」
- **內容**: 可執行的命令序列
- **影響**: 自動化重複性任務

**範例**:
- **Instruction**: "使用 Riverpod 進行狀態管理，遵循 feature-first 結構"
- **Workflow**: "執行 `flutter pub get` → `flutter build apk`"

## 📖 使用方式

### 方法 1: 在對話中引用
```
請參考 flutter-expert 指示來實作這個功能
```

### 方法 2: 在 Workflow 中嵌入
```markdown
---
description: Develop new feature
---

## Step 1: Read Instructions
Review @[.agent/instructions/flutter-expert.md]

## Step 2: Implement
[AI will follow the instructions]
```

### 方法 3: 在專案文件中引用
在 `GEMINI.md` 中引用這些指示，讓 AI 自動遵循。

## 🎯 專案特定注意事項

### HoldYourBeer Flutter 專案

**狀態管理**: Riverpod
**架構**: Feature-first
**響應式設計**: flutter_screenutil
**HTTP 客戶端**: Dio
**國際化**: flutter_localizations

所有指示都已針對此專案進行調整。

## 🔗 相關資源

- **Workflows**: `../workflows/` - 可執行的工作流程
- **Flutter 專案文件**: `../HoldYourBeer-Flutter/docs/` - 專案文檔
- **Flutter Session 記錄**: `../HoldYourBeer-Flutter/docs/sessions/` - 開發 session 歷史

## 📝 維護指南

### 新增指示
1. 創建新的 `.md` 文件
2. 遵循現有格式
3. 更新此 README
4. 在相關 workflow 中引用

### 更新指示
1. 根據專案演進更新內容
2. 保持與專案實際做法一致
3. 記錄重大變更

---

**Note**: 這些指示是為 Antigravity (Gemini) AI 助手設計的。對於 Claude Code，請參考 `/Users/kiddchan/Desktop/testVirtualization/laraDock/beer/.claude/` 目錄。


---

比較

git-commit-tw.md  跟直接用這串文字`用繁中 commit，遵循 conventional commits` ，誰的token開銷比較大？


這取決於您想要解決的問題層級：

1. 簡單場景（適合短文字）
如果您只是要一個「格式正確」的 commit，且您不介意細節（例如 scope 寫什麼、footer 格式），那麼短文字就夠了，也最省錢。

2. 專案/團隊場景（適合 .agent 檔案）
git-commit-tw.md 這個檔案雖然當下讀取較貴，但它包含了短文字無法傳達的隱性規則，這些規則能幫您省下「做錯重來」的巨大開銷：

- 定義了 Scope：檔案裡規定了 Flutter 專案只能用 ui, state, api 等。如果只用短文字，AI 可能會自創 login-page 或 widget-fix 這種不一致的 scope。

- 安全檢查：檔案裡有一段「敏感檔案警告清單」。如果只用短文字，AI 可能會不小心把 .env 或 secrets.json commit 進去。這時候的代價就不是 Token 能衡量的了。

-複雜格式：如果要寫 Breaking Change，檔案裡有標準範本。短文字很難每次都描述清楚「Breaking Change 要在 footer 寫清楚遷移方法」。

結論：如何選擇？
- 省錢模式：對於簡單、一次性的修改，直接下指令：「用繁中 Conventional Commits」。
- 專業模式：對於重要功能提交、涉及敏感檔案、或需要高度一致性的協作時，引用 @git-commit-tw。

最佳策略： 其實您可以把 git-commit-tw.md 當作「保險」。 平時您可以只說「commit」，AI 會根據它的訓練做個大概。 但當您發現 AI 開始亂寫 scope 或格式跑掉時，您不需要花時間打字教它，只要說「請遵守 @git-commit-tw」，它就會立刻回到正軌。這就是 .agent 存在的價值——標準化的知識庫。