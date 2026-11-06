# 我的待辦清單：Git 練習專案

一個用來練習 Git 和 GitHub 的小網頁。你會扮演一個用 AI 寫程式的新手：每一關，AI 都會對專案做一些事，有時很好，有時會把東西改壞。你的任務是用 Git 把專案管理好。

## 怎麼開始

1. 完成 [第 00 關：準備工具](practice/levels/00-準備.md)，安裝 Git 和 Git Bash。
2. 點這個頁面上綠色的 **Code** 按鈕，選 **Download ZIP**，解壓縮。
   > 不要用 `git clone`。第 01 關要從一個普通資料夾開始，親手執行 `git init`。
3. 在解壓縮出來的資料夾裡，按右鍵選 **Open Git Bash here**。
4. 照著 [第 01 關](practice/levels/01-開天闢地.md) 的說明開始。

## 每一關怎麼玩

```bash
bash practice/start.sh 2    # 開始第 2 關：AI 會對專案做一些事
                            # ……照著關卡說明，用 Git 處理……
bash practice/check.sh 2    # 檢查有沒有過關
```

有些關卡不需要 `start.sh`，關卡說明裡會寫清楚。

## 關卡地圖

### Part 1：本機 Git

| 關卡 | 你會練到 |
|---|---|
| [00 準備工具](practice/levels/00-準備.md) | 安裝 Git、`git config` |
| [01 開天闢地](practice/levels/01-開天闢地.md) | `git init`、`add`、`commit`、`.gitignore` |
| [02 AI 改了什麼](practice/levels/02-AI改了什麼.md) | `git status`、`git diff`、好的 commit 訊息 |
| [03 一次只做一件事](practice/levels/03-一次只做一件事.md) | 把修改拆成多個 commit |
| [04 改壞了](practice/levels/04-改壞了.md) | `git restore` |
| [05 add 錯了](practice/levels/05-add錯了.md) | `git restore --staged` |
| [06 已經 commit 了](practice/levels/06-已經commit了.md) | `git log`、`git show`、`git revert` |
| [07 平行世界](practice/levels/07-平行世界.md) | `git switch -c`、`git merge` |
| [08 合併衝突](practice/levels/08-合併衝突.md) | 解決衝突 |

### Part 2：GitHub

| 關卡 | 你會練到 |
|---|---|
| [09 上雲端](practice/levels/09-上雲端.md) | `git remote`、`git push` |
| [10 部署上線](practice/levels/10-部署上線.md) | GitHub Pages、GitHub Actions |
| [11 第一個 PR](practice/levels/11-第一個PR.md) | GitHub Flow、Pull Request、CI、Squash and merge |
| [12 保護 main](practice/levels/12-保護main.md) | 分支保護（Rulesets） |
| [13 金鑰外洩（選做）](practice/levels/13-金鑰外洩.md) | pre-commit |

## 卡住了怎麼辦

- **先打 `git status`**。它會告訴你現在的狀況，常常也會提示下一步該做什麼。
- **畫面跳進看不懂的編輯器**：畫面下方有很多 `~` 是 Vim，輸入 `:wq` 再按 Enter 離開；有 `^X Exit` 是 nano，按 `Ctrl + X` 離開。
- **想整關重來**：用 `git log --oneline` 找到開始這一關之前的 commit，執行 `git reset --hard 編號`，再重新執行 `start.sh`。
- **問 AI**：把 `git status` 的輸出貼給 AI，問它現在該怎麼做。但記得，**不要把 `.env` 的內容或任何金鑰貼給 AI**。

## 專案裡有什麼

| 檔案 | 用途 |
|---|---|
| `index.html`、`style.css`、`app.js` | 待辦清單網頁本體 |
| `.gitignore`、`uploads/.gitignore` | 告訴 Git 哪些檔案不要管 |
| `.env.example` | 金鑰範本，真正的金鑰放在 `.env` |
| `.github/workflows/` | CI 檢查與 GitHub Pages 自動部署 |
| `.pre-commit-config.yaml` | commit 前的自動檢查（第 13 關） |
| `practice/` | 關卡說明與練習腳本，不需要修改 |
| `scripts/ci-check.sh` | CI 執行的檢查腳本 |
