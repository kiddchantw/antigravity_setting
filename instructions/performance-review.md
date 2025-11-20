# Flutter Performance Review & Optimization Instructions

> 當優化 Flutter 應用程式效能或診斷效能問題時使用這些指示。

## 使用時機

- 應用程式運行緩慢或卡頓
- 滾動或動畫時 UI 卡頓
- 記憶體消耗過高
- 過度的 widget 重建
- 啟動時間慢
- 應用程式包大小過大
- 幀率低於 60fps
- 使用者要求效能優化

## 效能優化檢查清單

### Widget 優化
- ✅ 盡可能使用 `const` 建構子以減少重建
- ✅ 實作適當的 widget key 使用以實現高效重建
- ✅ 將大型 widgets 分解為更小、可重用的元件
- ✅ 最小化 widget 樹深度
- ✅ 對不常變化的複雜 widgets 使用 `RepaintBoundary`
- ✅ 避免在 build 方法中進行昂貴的操作

### 重建優化
- ✅ 使用選擇性監聽最小化 widget 重建
- ✅ 對簡單狀態更新使用 `ValueListenableBuilder`
- ✅ 在適當時在自訂 widgets 中實作 `shouldRebuild`
- ✅ 正確分離 stateful 和 stateless widgets
- ✅ 對動畫使用 `AnimatedBuilder` 而非 `setState`
- ✅ 避免不必要地使用 global keys

### 列表與滾動效能
- ✅ 使用 `ListView.builder` 或 `ListView.separated` 實作高效的列表渲染
- ✅ 對網格佈局使用 `GridView.builder`
- ✅ 對長列表實作延遲載入
- ✅ 使用 `itemExtent` 或 `prototypeItem` 快取列表項目範圍
- ✅ 使用 `AutomaticKeepAliveClientMixin` 保留列表項目狀態
- ✅ 對大型資料集實作分頁
- ✅ 避免在 `itemBuilder` 中進行昂貴的計算

### 圖片優化
- ✅ 使用快取和適當解析度優化圖片載入
- ✅ 對網路圖片使用 `CachedNetworkImage`
- ✅ 將圖片調整為適當尺寸（避免大圖片）
- ✅ 使用圖片壓縮（建議使用 WebP 格式）
- ✅ 實作佔位符和淡入效果
- ✅ 預載關鍵圖片
- ✅ 高效使用 `Image.memory` 或 `Image.asset`

### 網路與快取
- ✅ 適當快取網路請求
- ✅ 實作請求防抖和節流
- ✅ 對多個並發請求使用 HTTP/2
- ✅ 壓縮 API 回應（gzip）
- ✅ 在適當時實作離線優先架構
- ✅ 使用過期策略快取 API 回應

### 記憶體管理
- ✅ 分析記憶體使用並修復記憶體洩漏
- ✅ 正確處置 controllers、streams 和 listeners
- ✅ 避免 StatefulWidgets 中的記憶體洩漏（dispose 方法）
- ✅ 對循環引用使用 `WeakReference`
- ✅ 在適當時清除圖片快取
- ✅ 使用 DevTools 監控記憶體使用

### 計算效能
- ✅ 對繁重的計算任務使用 isolates
- ✅ 將昂貴的操作移出 UI 執行緒
- ✅ 對一次性計算使用 `compute()` 函數
- ✅ 實作資料解析的背景處理
- ✅ 優化演算法複雜度（Big O）
- ✅ 對昂貴的函數結果使用記憶化

### 應用程式包與啟動
- ✅ 透過移除未使用的資源最小化應用程式包大小
- ✅ 對非關鍵功能使用延遲載入
- ✅ 優化資源壓縮
- ✅ 移除未使用的依賴項
- ✅ 使用 tree-shaking（在 release builds 中自動完成）
- ✅ 實作啟動畫面優化
- ✅ 延遲非關鍵初始化

### 動畫效能
- ✅ 對高效動畫使用 `AnimatedBuilder` 和 `AnimatedWidget`
- ✅ 優先使用 `Transform` 而非位置變化
- ✅ 謹慎使用 `Opacity` widget（昂貴）
- ✅ 在可能時快取動畫值
- ✅ 適當使用 `TickerProviderStateMixin`
- ✅ 避免對大型 widget 子樹進行動畫

## 分析與除錯工具

### Flutter DevTools
- ✅ 使用 **Performance overlay** 識別卡頓
- ✅ 使用 **Timeline view** 分析幀渲染
- ✅ 使用 **Memory view** 偵測記憶體洩漏
- ✅ 使用 **Network profiler** 監控 API 呼叫
- ✅ 使用 **CPU profiler** 找出瓶頸

### 命令列工具
```bash
# Performance overlay
flutter run --profile

# 分析應用程式大小
flutter build apk --analyze-size
flutter build ios --analyze-size

# 檢查效能問題
flutter analyze
```

### 分析 Widgets
```dart
import 'package:flutter/rendering.dart';

// 啟用效能覆蓋
debugProfileBuildsEnabled = true;
debugProfilePaintsEnabled = true;

// 檢查重建頻率
debugPrintRebuildDirtyWidgets = true;
```

## 常見效能問題

### 1. 過度重建
**症狀**: UI 感覺遲緩，CPU 使用率高
**解決方案**:
- 使用 `const` 建構子
- 實作適當的狀態管理範圍
- 使用 `ValueListenableBuilder` 或類似方法

### 2. N+1 渲染問題
**症狀**: 列表滾動卡頓
**解決方案**:
- 使用 `ListView.builder`
- 實作適當的項目回收
- 快取項目高度

### 3. 記憶體洩漏
**症狀**: 應用程式崩潰，記憶體無限增長
**解決方案**:
- 正確處置 controllers
- 取消訂閱 streams
- 使用 DevTools 記憶體分析器

### 4. 大型圖片
**症狀**: 圖片載入緩慢，記憶體高
**解決方案**:
- 適當調整圖片大小
- 使用快取策略
- 壓縮圖片

### 5. 同步阻塞操作
**症狀**: 操作期間 UI 凍結
**解決方案**:
- 使用 isolates 或 `compute()`
- 移至背景執行緒
- 正確實作 async/await

## 效能最佳實踐

1. **先測量**: 在優化前使用分析工具
2. **優化熱路徑**: 專注於頻繁執行的程式碼
3. **在真實裝置上測試**: 模擬器不反映真實效能
4. **分析 Release Builds**: Debug builds 較慢
5. **設定效能目標**: 目標為 60fps（每幀 16ms）
6. **監控記憶體**: 保持記憶體使用穩定
7. **逐步優化**: 進行小型、可測量的改進

## 平台特定優化

### Android
- 使用 R8/ProGuard 進行程式碼縮減
- 必要時啟用 multidex
- 優化原生程式庫載入
- 使用 Skia 渲染引擎優化

### iOS
- 啟用 bitcode（如適用）
- 優化資源目錄
- 使用 Metal 進行圖形處理
- 使用 Instruments 進行分析

## 要追蹤的效能指標

- **幀渲染時間**: < 16ms (60fps)
- **應用程式啟動時間**: < 3 秒
- **記憶體使用**: 穩定，無洩漏
- **包大小**: 盡可能小
- **網路請求**: 已快取和優化
- **電池使用**: 最小背景活動

## 額外資源

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Flutter DevTools](https://docs.flutter.dev/tools/devtools)
- [Performance profiling](https://docs.flutter.dev/perf/ui-performance)
