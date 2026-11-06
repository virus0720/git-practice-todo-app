# 講師準備說明

這份文件是給講師看的，學員不需要閱讀。

## 上架步驟

1. 在 GitHub 建立一個 **public** repo，例如 `git-practice-todo-app`。
2. 把這個資料夾的內容推上去：

   ```bash
   cd todo-app
   git init -b main
   git add .
   git commit -m "建立 Git 練習專案"
   git remote add origin https://github.com/你的帳號/git-practice-todo-app.git
   git push -u origin main
   ```

3. 把 repo 網址發給學員。學員用 **Code → Download ZIP** 下載，不是 clone，因為第 01 關要親手 `git init`。
4. 不需要把 repo 設成 template：學員在第 09 關會自己建立新的空 repo，再把本機專案推上去。

> 你自己的這份 repo 推上去之後，Actions 也會跑 CI 和 Pages 部署。Pages 沒開啟時部署會失敗，這不影響學員下載。想先示範成品，可以在 Settings → Pages 把 Source 設成 GitHub Actions。

## 和投影片的對應

| 投影片段落 | 關卡 |
|---|---|
| git init、.git、三個區域、.gitignore | 01 |
| git status、git diff | 02 |
| 如何寫好一個 commit、訊息結構 | 03 |
| 後悔藥：restore、restore --staged | 04、05 |
| revert 還是 reset | 06 |
| branch、分叉、merge | 07 |
| 衝突 | 08 |
| remote、帳號、開 repo、驗證 | 09 |
| GitHub Actions、CI/CD | 10 |
| GitHub Flow、PR | 11 |
| 保護 main | 12 |
| pre-commit、金鑰外洩 | 13 |

## 時間估算

| 範圍 | 時間 |
|---|---|
| 第 00 關（裝軟體） | 10～20 分鐘，建議課前完成 |
| 第 01～08 關 | 約 60 分鐘 |
| 第 09～12 關 | 約 45 分鐘 |
| 第 13 關（選做，需要 Python） | 15 分鐘 |

## 腳本設計

- `practice/start.sh N`：把專案變成第 N 關的情境，例如模擬 AI 修改檔案、建立有 bug 的 commit、製造衝突。AI 和同事的 commit 會用不同的作者名稱，學員在 `git log` 裡分得出來。
- `practice/check.sh N`：檢查是否過關，沒過會顯示原因和提示。
- 每關的狀態記錄在 `.git/practice/`，不會被 commit。
- 腳本用 bash 撰寫，Windows 學員在 Git Bash 裡執行，Mac 和 Linux 用內建的終端機。需要的工具（bash、git、perl、curl）Git for Windows 都已內建。
- `.gitattributes` 統一使用 LF 換行，避免 Windows 出現換行警告，或腳本因為 CRLF 而無法執行。

## 常見問題

- **學員卡在 Vim**：關卡說明裡的 `revert` 和合併都加上了 `--no-edit`。萬一還是跳進去，輸入 `:wq` 再按 Enter。
- **第 09 關 push 時沒跳出登入視窗**：請學員安裝 GitHub CLI，執行 `gh auth login`。
- **第 12 關 push 竟然成功**：確認 Ruleset 是 Active、Target 包含預設分支。免費方案只對 public repo 生效。
- **第 13 關裝不起來 pre-commit**：多半是 Python 沒加進 PATH。這關是選做，可以課後再試。
