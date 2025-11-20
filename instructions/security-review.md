# Flutter Security Review Instructions

> 當審查 Flutter/Dart 程式碼的安全漏洞和最佳實踐時使用這些指示。

## 使用時機

- 使用者要求審查程式碼的安全問題
- 審核認證或授權邏輯
- 驗證資料保護機制
- 檢查權限處理
- 驗證 API 安全性
- 部署前安全評估
- 一般安全程式碼審查

## 安全檢查清單

### 輸入驗證與資料清理
- ✅ 驗證和清理所有使用者輸入
- ✅ 實作適當的表單驗證
- ✅ 檢查文字欄位中的注入漏洞
- ✅ 在發送到後端 API 之前驗證資料

### 資料儲存與保護
- ✅ 使用 `flutter_secure_storage` 或平台 keychains 安全地儲存敏感資料
- ✅ 絕不在 SharedPreferences 或純文字中儲存敏感資料
- ✅ 為本地資料庫實作適當的加密（sqflite_sqlcipher）
- ✅ 不再需要時從記憶體中清除敏感資料

### 認證與授權
- ✅ 實作適當的認證 token 管理
- ✅ 使用安全的 token 儲存（flutter_secure_storage）
- ✅ 實作 token 刷新機制
- ✅ 優雅地處理認證過期
- ✅ 處理敏感資料時實作生物辨識認證
- ✅ 使用 OAuth 2.0 或類似的業界標準認證

### 網路安全
- ✅ 所有網路請求使用 HTTPS
- ✅ 為敏感應用程式實作憑證固定（certificate pinning）
- ✅ 正確驗證 SSL 憑證
- ✅ 避免在程式碼中暴露 API keys 或 secrets（使用環境變數或 build configs）
- ✅ 實作不洩漏敏感資訊的適當錯誤處理

### 權限與平台安全
- ✅ 在 iOS 和 Android 上正確處理權限
- ✅ 請求最少必要權限
- ✅ 向使用者解釋權限用途
- ✅ 優雅地處理權限拒絕
- ✅ 在存取受保護資源之前檢查權限

### Deep Links 與導航
- ✅ 驗證 deep links 和導航參數
- ✅ 在 deep link 路由上實作認證檢查
- ✅ 清理 URL 參數
- ✅ 防止未授權導航到敏感畫面

### 程式碼安全
- ✅ 為 production builds 混淆程式碼（`--obfuscate --split-debug-info`）
- ✅ 在 production 中移除 debug 程式碼和日誌
- ✅ 避免硬編碼 secrets、API keys 或敏感資料
- ✅ 使用環境變數進行配置
- ✅ 實作不暴露堆疊追蹤的適當錯誤處理

### 依賴項與更新
- ✅ 定期更新依賴項以修補安全漏洞
- ✅ 審查依賴項安全公告
- ✅ 使用 `flutter pub outdated` 檢查更新
- ✅ 審核第三方套件的安全問題

### 平台特定考量

**Android**:
- ✅ 使用 ProGuard/R8 進行程式碼混淆
- ✅ 必要時實作 root 偵測
- ✅ 安全的 Android Keystore 使用
- ✅ 驗證應用程式簽名憑證

**iOS**:
- ✅ 使用 Keychain 儲存敏感資料
- ✅ 必要時實作越獄偵測
- ✅ 遵循 iOS 安全指南
- ✅ 使用 App Transport Security (ATS)

## 常見漏洞檢查

1. **不安全的資料儲存**: 檢查 SharedPreferences、本地檔案、資料庫
2. **傳輸層保護不足**: 驗證 HTTPS 使用
3. **不安全的認證**: 檢查 token 處理、session 管理
4. **不當的平台使用**: 審查權限使用、平台 APIs
5. **程式碼品質問題**: 尋找硬編碼的 secrets、debug 程式碼
6. **不安全的通訊**: 檢查 API 呼叫、WebSocket 連線
7. **不良的授權**: 驗證存取控制、基於角色的權限

## 安全測試建議

- 使用各種使用者角色和權限進行測試
- 嘗試 SQL 注入和 XSS 攻擊（如適用）
- 測試認證繞過場景
- 檢查日誌中的敏感資料
- 驗證加密儲存
- 使用代理工具測試網路請求（Charles、Burp Suite）
- 審查應用程式在 rooted/jailbroken 裝置上的行為

## 專案特定注意事項

### HoldYourBeer Flutter 專案

**認證**:
- 使用 Google OAuth 2.0
- Token 儲存在 flutter_secure_storage
- 實作 token 刷新機制

**API 安全**:
- 所有 API 呼叫使用 HTTPS
- 使用 Dio interceptors 處理認證
- 實作適當的錯誤處理

**資料保護**:
- 敏感資料使用 flutter_secure_storage
- 本地資料庫加密（如需要）

## 額外資源

- [OWASP Mobile Security Testing Guide](https://owasp.org/www-project-mobile-security-testing-guide/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- 平台安全指南（Android & iOS）
