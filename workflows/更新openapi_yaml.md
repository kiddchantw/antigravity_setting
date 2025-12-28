---
description: 從 Laravel 專案產生 OpenAPI 規格，並自動產生 Flutter 的 API 客戶端程式碼
---

## 📋 前置條件

- ✅ Laravel 專案已安裝 Scribe (`knuckleswtf/scribe`)
- ✅ Flutter 專案已安裝 OpenAPI Generator 相關依賴
- ✅ Laradock 環境已啟動
- ✅ 已安裝 OpenAPI Generator CLI (`brew install openapi-generator`)

## 🚀 執行步驟

### 方式 A: 使用自動化腳本（推薦）

從 Flutter 專案根目錄執行：

```bash
cd HoldYourBeer-Flutter
./scripts/generate-api-client.sh
```

腳本會自動完成以下步驟：
1. 檢查 openapi.yaml 是否存在
2. 清理舊的產生程式碼
3. 執行 OpenAPI Generator
4. 執行 build_runner 產生必要的程式碼

### 方式 B: 手動執行（逐步控制）

#### 1. 產生 OpenAPI 規格

從專案根目錄 (`beer/`) 執行：

```bash
cd HoldYourBeer
docker-compose -f ../../laradock/docker-compose.yml exec -w /var/www/beer/HoldYourBeer workspace php artisan scribe:generate --force
```

這會產生 OpenAPI 規格檔案到：
- `HoldYourBeer/storage/app/private/scribe/openapi.yaml` ⭐ **新位置**
- `HoldYourBeer/public/docs/` (文檔)

#### 2. 複製 openapi.yaml 到 Flutter 專案

```bash
cd ..  # 回到 beer/ 目錄
cp HoldYourBeer/storage/app/private/scribe/openapi.yaml HoldYourBeer-Flutter/openapi.yaml
```

#### 3. 產生 Flutter API 客戶端（OpenAPI Generator）

```bash
cd HoldYourBeer-Flutter

# 清理舊的產生程式碼（可選）
rm -rf lib/generated/api

# 執行 OpenAPI Generator
openapi-generator generate \
  -i openapi.yaml \
  -g dart-dio \
  -o lib/generated/api \
  --skip-validate-spec \
  --additional-properties=pubName=holdyourbeer_api,pubVersion=1.0.0,dateLibrary=core
```

#### 4. 執行 build_runner（產生 built_value 程式碼）

```bash
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📝 重要變更說明

### ⚠️ 架構變更（2025-12-03）

**HoldYourBeer Flutter 專案已從 Retrofit 遷移至 OpenAPI Generator：**

- ✅ **Single Source of Truth**: `openapi.yaml` 是唯一的 API 定義來源
- ✅ **自動產生客戶端**: 從 OpenAPI 規格自動產生型別安全的 API 客戶端
- ✅ **built_value 模型**: 使用 built_value 進行序列化（取代 json_serializable）
- ✅ **完整型別安全**: 所有 API 請求/回應都有型別定義

### 產生的檔案位置

```
HoldYourBeer-Flutter/
├── openapi.yaml                  # OpenAPI 規格（從 Laravel 複製）
├── lib/generated/api/            # 產生的 API 客戶端程式碼
│   ├── lib/
│   │   ├── holdyourbeer_api.dart    # 主要入口
│   │   └── src/
│   │       ├── api/              # 6 個 API 類別
│   │       ├── model/            # 60+ 資料模型
│   │       └── serializers.dart  # built_value serializers
│   └── doc/                      # API 文檔
```

### 使用方式

產生的 API 透過 Riverpod providers 提供：

```dart
// 在 widget 或 provider 中使用
final authApi = ref.watch(v1AuthenticationApiProvider);
final beerApi = ref.watch(v1BeerTrackingApiProvider);

// 呼叫 API
final response = await authApi.login(request: loginRequest);
```

詳見：`lib/core/network/README_OPENAPI.md`

## 🔄 更新頻率

- **後端 API 變更時**: 執行此 workflow 同步更新 Flutter 客戶端
- **建議**: 在每次 PR 提交前執行，確保前後端 API 定義同步

## 📚 相關文檔

- 遷移文檔: `docs/sessions/2025-12/03-openapi-generator-migration.md`
- 使用指南: `lib/core/network/README_OPENAPI.md`
- OpenAPI Generator 官方文檔: https://openapi-generator.tech/
