# 第 12 關：保護 main

> 對應投影片：保護 main：不准直接 push

## 情境

main 是正式上線的版本，每次合併都會自動部署。萬一有人（或 AI）不小心直接 push 到 main 呢？把它鎖起來。

## 任務

設定分支保護，然後親眼看到直接 push 被擋下。

## 步驟

1. 到 GitHub repo 的 **Settings → Rules → Rulesets**，點 **New ruleset** → **New branch ruleset**。
2. 設定：
   - **Ruleset Name**：`保護 main`
   - **Enforcement status**：**Active**
   - **Target branches**：點 **Add target** → **Include default branch**
   - 勾選 **Require a pull request before merging**
   - 確認 **Block force pushes** 有勾選
3. 按 **Create** 存檔。
4. 讓腳本在 main 上直接做一個 commit：

   ```bash
   bash practice/start.sh 12
   ```

5. 試著直接 push：

   ```bash
   git push
   ```

   你應該會看到 `GH013: Repository rule violations`，告訴你修改必須透過 pull request。

6. 這個 commit 還沒推上去，可以放心丟掉：

   ```bash
   git reset --hard origin/main
   ```

<details>
<summary>卡住了？看提示</summary>

- push 竟然成功了？回到 Rulesets 確認 Enforcement status 是 Active，而且 Target 包含預設分支。
- 這裡可以用 `git reset --hard`，是因為那個 commit 只存在你的電腦上。已經 push 出去的 commit，要用 `git revert`。

</details>

## 對 AI 說

> 「main 有分支保護，請開分支並用 PR 合併，不要直接 push 到 main。」

## 檢查

```bash
bash practice/check.sh 12
```
