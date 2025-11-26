# Create Session 使用範例

## 🚀 快速建立 Session（推薦）

### 範例 1: 直接傳入需求描述

```bash
# 一行指令建立 session，直接寫入需求
.agent/scripts/create-session.sh 實作離線同步功能

# 輸出：
# Goal: 實作離線同步功能
# Auto-generated feature name: offline-sync
# Press Enter to continue or type a custom feature name: 
# [按 Enter 或輸入自訂檔名]
#
# ✅ Session created: sessions/2025-11/26-offline-sync.md
```

**結果**：
- 檔案：`sessions/2025-11/26-offline-sync.md`
- Goal 段落已填入：「實作離線同步功能」
- 可以直接開始規劃實作細節

---

### 範例 2: 中文需求描述

```bash
.agent/scripts/create-session.sh 修復商品列表載入緩慢問題

# 自動生成檔名：fix-product-list-loading-slow
# Goal：修復商品列表載入緩慢問題
```

---

### 範例 3: 英文需求描述

```bash
.agent/scripts/create-session.sh implement user authentication with OAuth

# 自動生成檔名：implement-user-authentication-with-oauth
# Goal：implement user authentication with OAuth
```

---

## 🎯 互動式建立

如果不傳入參數，會進入互動式選單：

```bash
.agent/scripts/create-session.sh

# 選項：
# 1) From GitHub Issue (fetch issue details)
# 2) Manual (create session with goal prompt)
# 3) Empty (create empty template only)
```

### 選項 2: 手動建立

```
Choice: 2

Feature name (e.g., offline-sync): user-profile
Goal (one sentence, what are we trying to achieve?): 實作使用者個人資料頁面

✅ Session created: sessions/2025-11/26-user-profile.md
```

---

## 📝 工作流程

### 完整開發流程

```bash
# 1. 快速建立 session（寫入需求）
.agent/scripts/create-session.sh 實作商品收藏功能

# 2. 編輯 session，規劃實作細節
# - 填寫 Context（背景說明）
# - 填寫 Plan（技術方案）
# - 填寫 Implementation（實作步驟）

# 3. 如需新 branch，更新 session 中的 Branch 欄位後執行
.agent/scripts/create-branch.sh sessions/2025-11/26-product-favorite.md

# 4. 開始開發...

# 5. 完成後封存
.agent/scripts/archive-session.sh
```

---

## 💡 使用技巧

### 1. 需求描述建議

**好的範例**：
```bash
.agent/scripts/create-session.sh 實作商品搜尋功能
.agent/scripts/create-session.sh 修復登入頁面閃爍問題
.agent/scripts/create-session.sh 優化首頁載入速度
```

**避免太長**：
```bash
# ❌ 太長，會被截斷
.agent/scripts/create-session.sh 實作商品搜尋功能包含關鍵字搜尋分類篩選價格排序等功能

# ✅ 簡潔明確
.agent/scripts/create-session.sh 實作商品搜尋功能
# 詳細需求在 session 的 Context 中補充
```

### 2. 自訂檔名

如果自動生成的檔名不滿意，可以在提示時輸入自訂名稱：

```bash
.agent/scripts/create-session.sh 實作離線同步功能

# 輸出：
# Auto-generated feature name: offline-sync
# Press Enter to continue or type a custom feature name: sync-v2
#                                                        ^^^^^^
#                                                        輸入自訂名稱
```

### 3. 空白模板

如果只想建立空白模板：

```bash
.agent/scripts/create-session.sh

# 選擇選項 3
Choice: 3
```

---

## 🔄 與 Gemini Workflows 整合

在 Gemini 中可以直接使用 slash command：

```
/建立session 實作商品收藏功能
```

Gemini 會自動執行對應的腳本。

---

**Last Updated**: 2025-11-26
