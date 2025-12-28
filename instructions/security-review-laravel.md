# Laravel Security Review Instructions

> 當審查 Laravel/PHP 程式碼的安全漏洞和最佳實踐時使用這些指示。

## 使用時機

- 使用者要求審查程式碼的安全問題
- 審核認證或授權邏輯
- 驗證 API 端點安全性
- 檢查資料庫查詢安全
- 驗證輸入處理和資料驗證
- 部署前安全評估
- 一般安全程式碼審查

## 安全檢查清單

### 輸入驗證與資料清理

- ✅ 所有使用者輸入都經過驗證（使用 Form Requests 或 Validation Rules）
- ✅ 實作適當的驗證規則（required, email, max, min 等）
- ✅ 清理 HTML 輸入以防止 XSS 攻擊
- ✅ 使用 `strip_tags()` 或 HTMLPurifier 處理富文本
- ✅ 驗證檔案上傳（類型、大小、MIME type）
- ✅ 避免直接使用 `$request->all()` 進行資料庫操作

### SQL 注入防護

- ✅ 優先使用 Eloquent ORM 而非 Raw Queries
- ✅ 使用 Query Builder 時必須使用參數綁定
- ✅ 絕不直接拼接使用者輸入到 SQL 查詢
- ✅ 檢查 `DB::raw()` 使用是否安全
- ✅ 檢查 `whereRaw()`, `orderByRaw()` 等方法的參數
- ✅ 使用 `?` 佔位符或具名參數進行參數綁定

```php
// ❌ 不安全
DB::table('users')->whereRaw("name = '{$request->name}'")->get();

// ✅ 安全
DB::table('users')->whereRaw('name = ?', [$request->name])->get();
DB::table('users')->where('name', $request->name)->get();
```

### Mass Assignment 保護

- ✅ 所有 Model 都定義了 `$fillable` 或 `$guarded`
- ✅ 敏感欄位（如 `is_admin`, `role`, `balance`）不在 `$fillable` 中
- ✅ 使用 `$guarded = ['*']` 時要特別小心
- ✅ API 端點不直接使用 `$request->all()` 進行 create/update
- ✅ 使用 `$request->only()` 或 `$request->validated()` 限制可更新欄位

```php
// ❌ 不安全
User::create($request->all());

// ✅ 安全
User::create($request->validated());
User::create($request->only(['name', 'email', 'password']));
```

### 認證與授權

- ✅ 使用 Laravel 內建認證系統（Sanctum, Passport, Fortify）
- ✅ 密碼使用 `Hash::make()` 或 `bcrypt()` 加密
- ✅ 實作密碼強度驗證（minimum length, complexity）
- ✅ 所有需要認證的路由都使用 `auth` middleware
- ✅ 使用 Gates 和 Policies 進行授權檢查
- ✅ API 端點實作適當的 token 驗證
- ✅ 實作 token 刷新機制
- ✅ 登入失敗次數限制（throttling）
- ✅ 實作兩步驟驗證（2FA）於敏感操作

```php
// Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [UserController::class, 'show']);
});

// Controller
public function update(Request $request, Post $post)
{
    $this->authorize('update', $post); // 使用 Policy
    // ...
}
```

### CSRF 保護

- ✅ 所有 POST, PUT, PATCH, DELETE 路由都有 CSRF 保護
- ✅ 表單包含 `@csrf` blade directive
- ✅ API 路由使用 token 認證而非 session（不需要 CSRF）
- ✅ 檢查 `VerifyCsrfToken` middleware 的例外設定是否合理
- ✅ 避免在 `$except` 陣列中隨意排除路由

### XSS 防護

- ✅ 使用 Blade 模板引擎的 `{{ }}` 自動跳脫輸出
- ✅ 只在必要時使用 `{!! !!}` 輸出未跳脫內容
- ✅ 使用 `{!! !!}` 時確保內容已經過清理
- ✅ 使用 `e()` helper 手動跳脫字串
- ✅ 富文本編輯器輸出使用 HTMLPurifier 清理
- ✅ JSON 回應使用 `response()->json()` 而非手動建構

```php
// ✅ 安全 - 自動跳脫
{{ $user->name }}

// ⚠️ 小心使用 - 不跳脫
{!! $user->bio !!}  // 確保 bio 已清理過

// ✅ 手動跳脫
echo e($untrustedString);
```

### Session 安全

- ✅ `SESSION_DRIVER` 使用安全的驅動（database, redis）
- ✅ `SESSION_SECURE` 在生產環境設為 true（HTTPS only）
- ✅ `SESSION_HTTP_ONLY` 設為 true
- ✅ `SESSION_SAME_SITE` 設為 'lax' 或 'strict'
- ✅ Session lifetime 設定合理（不要太長）
- ✅ 敏感操作後重新產生 session ID

```php
// config/session.php
'secure' => env('SESSION_SECURE', true),
'http_only' => true,
'same_site' => 'lax',
```

### Cookie 安全

- ✅ 敏感 Cookie 設定 `HttpOnly` flag
- ✅ 生產環境 Cookie 設定 `Secure` flag（HTTPS only）
- ✅ 適當設定 `SameSite` 屬性
- ✅ 不在 Cookie 中儲存敏感資料（密碼、token）
- ✅ Cookie 加密（Laravel 預設）

### 檔案上傳安全

- ✅ 驗證檔案 MIME type 和副檔名
- ✅ 限制檔案大小
- ✅ 上傳的檔案重新命名（避免路徑遍歷）
- ✅ 儲存在 `storage` 目錄而非 `public`（除非必要）
- ✅ 使用 `Storage` facade 處理檔案
- ✅ 圖片上傳使用 image 驗證規則
- ✅ 檔案下載使用 `Storage::download()` 而非直接路徑

```php
// 驗證
$request->validate([
    'avatar' => 'required|image|mimes:jpeg,png,jpg|max:2048',
    'document' => 'required|file|mimes:pdf,docx|max:10240',
]);

// 儲存
$path = $request->file('avatar')->store('avatars', 'private');

// 下載
return Storage::download($path, $originalName);
```

### API 安全

- ✅ API 路由使用認證（Sanctum, Passport）
- ✅ 實作 Rate Limiting（`throttle` middleware）
- ✅ 驗證 API token 的有效性和權限
- ✅ API 回應不包含敏感資料（密碼、內部 ID）
- ✅ 使用 API Resources 控制輸出欄位
- ✅ 實作適當的錯誤處理（不洩漏系統資訊）
- ✅ CORS 設定正確（不使用 `*` 允許所有來源）
- ✅ API 版本控制

```php
// routes/api.php
Route::middleware(['auth:sanctum', 'throttle:60,1'])->group(function () {
    Route::apiResource('posts', PostController::class);
});

// Resources
return new UserResource($user); // 只返回需要的欄位
```

### 環境變數與設定安全

- ✅ `.env` 檔案不納入版控
- ✅ `.env` 包含在 `.gitignore`
- ✅ 敏感資料（API keys, secrets）存在 `.env`
- ✅ `APP_DEBUG` 在生產環境設為 false
- ✅ `APP_ENV` 在生產環境設為 production
- ✅ 資料庫密碼使用強密碼
- ✅ `APP_KEY` 已設定且足夠強（`php artisan key:generate`）
- ✅ 不在程式碼中硬編碼 credentials
- ✅ 使用 `config()` 而非 `env()` 在程式碼中讀取設定

```php
// ❌ 不要在程式碼中使用
env('API_KEY')

// ✅ 使用 config
config('services.stripe.key')
```

### 資料庫安全

- ✅ 使用資料庫遷移（Migrations）而非手動建表
- ✅ 敏感欄位使用加密（`encrypted` cast）
- ✅ 資料庫連線使用最小權限帳號
- ✅ 定期備份資料庫
- ✅ 索引敏感查詢欄位（防止性能攻擊）
- ✅ 使用軟刪除（Soft Deletes）保留審計紀錄
- ✅ 不在 log 中記錄敏感資料

```php
// Model
protected $casts = [
    'credit_card' => 'encrypted',
    'ssn' => 'encrypted',
];
```

### 授權與權限

- ✅ 使用 Policies 定義授權邏輯
- ✅ 使用 Gates 定義簡單權限檢查
- ✅ Controller 中使用 `authorize()` 或 `can()` 檢查權限
- ✅ Blade 模板使用 `@can` directive
- ✅ 實作基於角色的存取控制（RBAC）
- ✅ 敏感操作需要額外驗證（如密碼確認）

```php
// Policy
public function update(User $user, Post $post)
{
    return $user->id === $post->user_id;
}

// Controller
$this->authorize('update', $post);

// Blade
@can('update', $post)
    <a href="{{ route('posts.edit', $post) }}">編輯</a>
@endcan
```

### 錯誤處理與日誌

- ✅ 生產環境不顯示詳細錯誤訊息
- ✅ 自訂錯誤頁面（404, 500 等）
- ✅ 記錄安全相關事件（登入失敗、權限拒絕）
- ✅ 不在日誌中記錄敏感資料（密碼、token）
- ✅ 定期審查日誌檔案
- ✅ 使用 Laravel Telescope 或 Log 監控工具

### 依賴項與更新

- ✅ 定期更新 Laravel 框架版本
- ✅ 定期更新 Composer 依賴項
- ✅ 使用 `composer audit` 檢查已知漏洞
- ✅ 審查第三方套件的安全問題
- ✅ 移除不使用的依賴項
- ✅ 使用 `composer.lock` 鎖定版本

```bash
composer audit
composer outdated
composer update --with-all-dependencies
```

### HTTPS 與傳輸安全

- ✅ 生產環境強制使用 HTTPS
- ✅ 使用 `TrustProxies` middleware（如在 Load Balancer 後）
- ✅ 設定 HSTS header
- ✅ 使用 `URL::forceScheme('https')` 強制 HTTPS URL
- ✅ 外部 API 呼叫使用 HTTPS
- ✅ 驗證 SSL 憑證有效性

```php
// AppServiceProvider
if ($this->app->environment('production')) {
    URL::forceScheme('https');
}
```

### 程式碼品質與安全

- ✅ 避免使用 `eval()`, `exec()`, `shell_exec()` 等危險函數
- ✅ 使用 `serialize()` 時要小心反序列化攻擊
- ✅ 避免使用 `extract()` 處理使用者輸入
- ✅ 使用 PHPStan 或 Psalm 進行靜態分析
- ✅ 使用 PHP CS Fixer 維持程式碼品質
- ✅ 實作單元測試和功能測試
- ✅ 程式碼審查（Code Review）

## 常見漏洞檢查（OWASP Top 10）

1. **Injection（注入攻擊）**
   - SQL Injection
   - Command Injection
   - LDAP Injection

2. **Broken Authentication（失效的身份認證）**
   - 弱密碼政策
   - Session 管理不當
   - 缺少 2FA

3. **Sensitive Data Exposure（敏感資料洩漏）**
   - 明文儲存密碼
   - 不使用 HTTPS
   - 不適當的加密

4. **XML External Entities (XXE)**
   - 不安全的 XML 解析

5. **Broken Access Control（失效的存取控制）**
   - 缺少授權檢查
   - IDOR (Insecure Direct Object Reference)

6. **Security Misconfiguration（安全設定錯誤）**
   - Debug mode 開啟
   - 預設帳號密碼
   - 不必要的服務開啟

7. **Cross-Site Scripting (XSS)**
   - Stored XSS
   - Reflected XSS
   - DOM-based XSS

8. **Insecure Deserialization（不安全的反序列化）**
   - 不安全的 `unserialize()`

9. **Using Components with Known Vulnerabilities（使用已知漏洞的元件）**
   - 過舊的依賴項
   - 未修補的套件

10. **Insufficient Logging & Monitoring（記錄與監控不足）**
    - 缺少審計日誌
    - 無監控告警

## 安全測試建議

### 自動化測試

```bash
# 執行安全測試
php artisan test --filter Security

# 檢查依賴項漏洞
composer audit

# 靜態分析
./vendor/bin/phpstan analyse

# 程式碼風格
./vendor/bin/php-cs-fixer fix --dry-run
```

### 手動測試

- 嘗試 SQL Injection 攻擊
- 測試 CSRF token 繞過
- 嘗試 Mass Assignment 攻擊
- 測試未授權存取
- 檢查 XSS 漏洞
- 測試檔案上傳限制
- 驗證 Rate Limiting
- 測試 Session Fixation
- 檢查 IDOR 漏洞

### 工具推薦

- **OWASP ZAP**: Web 應用程式安全掃描
- **Burp Suite**: HTTP 請求攔截與測試
- **Laravel Security Checker**: Laravel 特定安全檢查
- **SonarQube**: 程式碼品質與安全分析
- **Snyk**: 依賴項漏洞掃描

## 部署前檢查清單

- [ ] `APP_DEBUG=false`
- [ ] `APP_ENV=production`
- [ ] 所有敏感設定在 `.env`
- [ ] HTTPS 啟用並強制
- [ ] CSRF 保護啟用
- [ ] Rate Limiting 設定
- [ ] 錯誤頁面自訂
- [ ] 日誌監控設定
- [ ] 資料庫備份設定
- [ ] SSL 憑證有效
- [ ] 依賴項更新到最新穩定版
- [ ] 安全 headers 設定（CSP, X-Frame-Options 等）

## 安全 Headers 設定

在 `config/cors.php` 或 middleware 中設定：

```php
// SecurityHeadersMiddleware
public function handle($request, Closure $next)
{
    $response = $next($request);

    $response->headers->set('X-Content-Type-Options', 'nosniff');
    $response->headers->set('X-Frame-Options', 'SAMEORIGIN');
    $response->headers->set('X-XSS-Protection', '1; mode=block');
    $response->headers->set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
    $response->headers->set('Content-Security-Policy', "default-src 'self'");

    return $response;
}
```

## 專案特定注意事項

### HoldYourBeer Laravel API 專案

**認證**:
- 使用 Laravel Sanctum
- API token 認證
- Google OAuth 2.0 整合

**API 安全**:
- 所有端點需要認證
- Rate Limiting: 60 requests/minute
- CORS 限制特定來源

**資料保護**:
- 敏感欄位加密
- 使用 API Resources 控制輸出
- 實作適當的授權檢查

**資料庫**:
- PostgreSQL
- 使用 Eloquent ORM
- 所有查詢使用參數綁定

## 額外資源

- [Laravel Security Best Practices](https://laravel.com/docs/security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Laravel Security Package](https://github.com/phpstan/phpstan)
- [PHP Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/PHP_Configuration_Cheat_Sheet.html)
- [Snyk Vulnerability Database](https://snyk.io/vuln/)

## 定期安全審查

建議每 **3-6 個月**執行一次完整安全審查，或在以下情況：

- 新功能上線前
- 重大更新後
- 發現安全事件後
- 依賴項重大更新後
- 架構變更後
