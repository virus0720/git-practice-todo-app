#!/usr/bin/env bash
# 檢查一個關卡有沒有過關
# 用法：bash practice/check.sh 關卡編號，例如 bash practice/check.sh 2

. "$(dirname "$0")/lib.sh"

LEVEL="$(printf '%s' "${1:-}" | sed 's/^0*//')"
[ -n "${1:-}" ] || die "請加上關卡編號，例如：bash practice/check.sh 2"
[ -n "$LEVEL" ] || LEVEL=0

say "${B}檢查第 $LEVEL 關${N}"

# 一個 commit 改了哪些檔案
files_of() { git diff-tree --no-commit-id --name-only -r "$1"; }

case "$LEVEL" in

  0)
    if ! command -v git >/dev/null 2>&1; then
      die "找不到 git。請先安裝 Git，Windows 請安裝 Git for Windows。"
    fi
    ver="$(git --version | sed 's/[^0-9]*\([0-9]*\)\.\([0-9]*\).*/\1 \2/')"
    set -- $ver
    if [ "${1:-0}" -gt 2 ] || { [ "${1:-0}" -eq 2 ] && [ "${2:-0}" -ge 28 ]; }; then
      pass "Git 已安裝：$(git --version)"
    else
      fail "Git 版本太舊（$(git --version)），請更新到 2.28 以上。"
    fi
    if [ -n "$(git config --global user.name)" ]; then
      pass "已設定名字：$(git config --global user.name)"
    else
      fail "還沒設定名字。"; hint 'git config --global user.name "你的名字"'
    fi
    if [ -n "$(git config --global user.email)" ]; then
      pass "已設定信箱：$(git config --global user.email)"
    else
      fail "還沒設定信箱。"; hint 'git config --global user.email "you@example.com"'
    fi
    finish "到 practice/levels/01-開天闢地.md 開始第 01 關。"
    ;;

  1)
    need_repo
    pass "這個資料夾已經是 Git 儲存庫"
    if [ "$(branch)" = "main" ]; then pass "目前在 main 分支"
    else fail "目前在 $(branch) 分支，應該要叫 main。"; hint "git branch -M main"; fi
    if git rev-parse -q --verify HEAD >/dev/null; then pass "已經有 commit 了"
    else fail "還沒有任何 commit。"; hint "git add . 之後執行 git commit -m \"建立待辦清單專案\""; fi
    if [ -f .env ]; then pass "已經建立 .env"
    else fail "還沒建立 .env。"; hint "cp .env.example .env"; fi
    if git ls-files --error-unmatch .env >/dev/null 2>&1; then
      fail ".env 被 Git 追蹤了！金鑰不應該進 commit。"
      hint "git rm --cached .env 把它移出追蹤，再 commit 一次。"
    else pass ".env 沒有被 commit，金鑰很安全"; fi
    if git ls-files --error-unmatch index.html app.js style.css .gitignore >/dev/null 2>&1; then
      pass "網頁檔案和 .gitignore 都存進 commit 了"
    else fail "有檔案還沒存進 commit。"; hint "用 git status 看看哪些檔案是紅色的。"; fi
    if is_clean; then pass "工作區是乾淨的"
    else fail "還有修改沒有 commit。"; fi
    finish "第 02 關：執行 bash practice/start.sh 2"
    ;;

  2)
    need_repo; need_started 2
    start="$(recall start-2)"
    if [ "$(git rev-parse HEAD)" != "$start" ]; then pass "已經做了新的 commit"
    else fail "還沒有 commit AI 的修改。"; fi
    if git show HEAD:style.css | grep -qF 'h1 { color: teal; }'; then pass "青綠色主題存進 commit 了"
    else fail "最新的 commit 裡沒有青綠色主題。"; fi
    msg="$(git log -1 --format=%s)"
    if vague_msg "$msg"; then fail "commit 訊息「$msg」太模糊了。"; hint "寫清楚做了什麼，例如「網頁改成青綠色主題」。可以用 git commit --amend -m \"新訊息\" 修改。"
    else pass "commit 訊息：$msg"; fi
    if is_clean; then pass "工作區是乾淨的"; else fail "還有修改沒有 commit。"; fi
    finish "第 03 關：執行 bash practice/start.sh 3"
    ;;

  3)
    need_repo; need_started 3
    start="$(recall start-3)"
    n="$(git rev-list --count "$start"..HEAD)"
    if [ "$n" -eq 3 ]; then pass "做了 3 個 commit"
    else fail "應該要有 3 個 commit，目前有 $n 個。"
      [ "$n" -lt 3 ] && hint "用 git add 檔名 一次只放一個檔案，再 commit。"
      [ "$n" -gt 3 ] && hint "想重來的話：git reset --hard $start，再執行 bash practice/start.sh 3"
    fi
    all=""
    for c in $(git rev-list "$start"..HEAD); do
      f="$(files_of "$c")"
      cnt="$(printf '%s\n' "$f" | grep -c .)"
      msg="$(git log -1 --format=%s "$c")"
      if [ "$cnt" -eq 1 ]; then pass "「$msg」只改了 $f"
      else fail "「$msg」一次改了 $cnt 個檔案：$(printf '%s' "$f" | tr '\n' ' ')"; fi
      if vague_msg "$msg"; then fail "commit 訊息「$msg」太模糊了。"; fi
      all="$all $f"
    done
    for f in index.html app.js style.css; do
      case "$all" in *"$f"*) ;; *) fail "$f 的修改還沒 commit。" ;; esac
    done
    if is_clean; then pass "工作區是乾淨的"; else fail "還有修改沒有 commit。"; fi
    finish "第 04 關：執行 bash practice/start.sh 4"
    ;;

  4)
    need_repo; need_started 4
    start="$(recall start-4)"
    if [ "$(git rev-parse HEAD)" = "$start" ]; then pass "沒有把壞掉的程式存進 commit"
    else fail "多了新的 commit。這一關不需要 commit，要把修改丟掉。"
      hint "git reset --hard $start 可以回到開始這一關的時候"; fi
    if is_clean; then pass "AI 的修改都丟掉了，檔案回到原本的樣子"
    else fail "還有沒處理的修改。"; hint "git restore app.js style.css，或一次全部：git restore ."; fi
    finish "第 05 關：執行 bash practice/start.sh 5"
    ;;

  5)
    need_repo; need_started 5
    start="$(recall start-5)"
    if [ "$(git rev-parse HEAD)" != "$start" ]; then pass "已經做了新的 commit"
    else fail "還沒有 commit。"; fi
    if git show HEAD:app.js | grep -qF '已完成'; then pass "「已完成幾件」的功能存進 commit 了"
    else fail "app.js 的修改還沒存進 commit。"; fi
    if git cat-file -e HEAD:ai-notes.md 2>/dev/null; then
      fail "ai-notes.md 被存進 commit 了。"
      hint "git reset --soft HEAD~1 退回上一步，再用 git restore --staged ai-notes.md 拿出來。"
    else pass "ai-notes.md 沒有進 commit"; fi
    if git diff --cached --quiet; then pass "暫存區是空的"
    else fail "暫存區裡還有東西。"; fi
    [ -f ai-notes.md ] && hint "ai-notes.md 還留在資料夾裡，這是正常的：restore --staged 不會刪掉檔案。用不到的話可以直接刪除。"
    finish "第 06 關：執行 bash practice/start.sh 6"
    ;;

  6)
    need_repo; need_started 6
    bug="$(recall bug-6)"
    if git merge-base --is-ancestor "$bug" HEAD 2>/dev/null; then pass "壞掉的 commit 還留在歷史裡（revert 不刪除歷史）"
    else fail "壞掉的 commit 不見了。這一關要用 revert，不要用 reset。"
      hint "重來：bash practice/start.sh 6"; fi
    if [ "$(git rev-parse HEAD:app.js)" = "$(recall before-6)" ]; then pass "app.js 回到 AI 修改前的樣子"
    else fail "app.js 和 AI 修改前不一樣。"; fi
    case "$(git log -1 --format=%s)" in
      Revert*) pass "最新的 commit 是 revert：$(git log -1 --format=%s)" ;;
      *) fail "最新的 commit 不是 revert。"; hint "git revert HEAD --no-edit" ;;
    esac
    if is_clean; then pass "工作區是乾淨的"; else fail "還有修改沒有 commit。"; fi
    finish "第 07 關：先執行 git switch -c feature-search，再執行 bash practice/start.sh 7"
    ;;

  7)
    need_repo; need_started 7
    if [ "$(branch)" = "main" ]; then pass "目前在 main 分支"
    else fail "目前在 $(branch)，最後要回到 main。"; hint "git switch main"; fi
    if git show main:index.html | grep -qF 'search-input'; then pass "搜尋功能已經合併進 main"
    else fail "main 裡還沒有搜尋功能。"; hint "在 main 上執行 git merge feature-search"; fi
    if has_branch feature-search; then fail "feature-search 分支還在。"; hint "合併完就可以刪掉：git branch -d feature-search"
    else pass "用完的 feature-search 分支已經刪除"; fi
    if is_clean; then pass "工作區是乾淨的"; else fail "還有修改沒有 commit。"; fi
    finish "第 08 關：執行 bash practice/start.sh 8"
    ;;

  8)
    need_repo; need_started 8
    theirs="$(recall theirs-8)"
    if [ -f "$(git rev-parse --git-dir)/MERGE_HEAD" ]; then
      fail "合併還沒完成。"; hint "解決衝突後執行 git add style.css，再執行 git commit --no-edit"
    fi
    parents="$(git log -1 --format=%P | wc -w | tr -d ' ')"
    if [ "$parents" -eq 2 ] && git log -1 --format=%P | grep -q "$theirs"; then pass "合併 commit 建立好了，它有兩個上一個 commit"
    else fail "最新的 commit 不是 feature-color 的合併 commit。"; hint "git merge feature-color"; fi
    if git grep -nE '^(<<<<<<<|=======|>>>>>>>)' -- '*.html' '*.css' '*.js' >/dev/null 2>&1; then
      fail "檔案裡還有衝突標記："; git grep -nE '^(<<<<<<<|=======|>>>>>>>)' -- '*.html' '*.css' '*.js'
    else pass "衝突標記都清乾淨了"; fi
    color="$(grep -E '^h1 \{ color: ' style.css)"
    [ -n "$color" ] && pass "你選擇的標題顏色：$color"
    if is_clean; then pass "工作區是乾淨的"; else fail "還有修改沒有 commit。"; fi
    has_branch feature-color && hint "feature-color 用完了，可以用 git branch -d feature-color 刪掉。"
    finish "Part 1 完成！第 09 關要把專案推上 GitHub，說明在 practice/levels/09-上雲端.md"
    ;;

  9)
    need_repo; need_commit
    if git remote get-url origin >/dev/null 2>&1; then pass "已經設定遠端 origin：$(git remote get-url origin)"
    else die "還沒有設定遠端。請執行 git remote add origin 你的 repo 網址"; fi
    if git fetch -q origin 2>/dev/null; then pass "連得上 GitHub"
    else die "連不上 GitHub。請確認網址正確，並完成登入（gh auth login）。"; fi
    if git rev-parse -q --verify origin/main >/dev/null; then
      if [ "$(git rev-parse main)" = "$(git rev-parse origin/main)" ]; then pass "GitHub 上的 main 和你電腦上的一樣"
      else fail "GitHub 上的 main 和本機不一樣。"; hint "git push"; fi
    else fail "GitHub 上還沒有 main。"; hint "git push -u origin main"; fi
    finish "第 10 關：說明在 practice/levels/10-部署上線.md"
    ;;

  10)
    need_repo
    site="$(pages_url)" || die "還沒有設定遠端 origin，請先完成第 09 關。"
    say "檢查網址：$site"
    code="$(curl -s -L -o "$STATE_DIR/page.html" -w '%{http_code}' "$site")"
    if [ "$code" = "200" ] && grep -q '清單' "$STATE_DIR/page.html"; then pass "網站上線了！"
    else fail "網站還打不開（HTTP $code）。"
      hint "確認 Settings → Pages 的 Source 選了 GitHub Actions，再到 Actions 分頁重新執行 Deploy to GitHub Pages。第一次部署可能要等一兩分鐘。"; fi
    finish "把網址分享給朋友看看！第 11 關：說明在 practice/levels/11-第一個PR.md"
    ;;

  11)
    need_repo
    git fetch -q --prune origin || die "連不上 GitHub。"
    if git show origin/main:style.css | grep -qF 'prefers-color-scheme'; then pass "深色模式已經合併進 GitHub 上的 main"
    else fail "GitHub 上的 main 還沒有深色模式。"; hint "到 GitHub 的 Pull Request 頁面，等 CI 通過後合併。"; fi
    c="$(git log origin/main -1 --format=%H -S'prefers-color-scheme' -- style.css)"
    if [ -n "$c" ]; then
      if [ "$(git log -1 --format=%P "$c" | wc -w | tr -d ' ')" -eq 1 ]; then pass "用 Squash and merge 合併，main 的歷史很乾淨"
      else hint "這次是用一般的 merge 合併的。下次可以試試 Squash and merge。"; fi
    fi
    if [ "$(git rev-parse main)" = "$(git rev-parse origin/main)" ]; then pass "本機的 main 已經更新"
    else fail "本機的 main 還是舊的。"; hint "git switch main，然後 git pull"; fi
    has_branch feature-dark-mode && hint "本機還有 feature-dark-mode 分支。squash 合併後要用大寫 -D 刪除：git branch -D feature-dark-mode"
    finish "過一兩分鐘再打開你的網站，切換電腦的深色模式看看！第 12 關：說明在 practice/levels/12-保護main.md"
    ;;

  12)
    need_repo; need_started 12
    git fetch -q origin || die "連不上 GitHub。"
    direct="$(recall direct-12)"
    if git merge-base --is-ancestor "$direct" origin/main 2>/dev/null; then
      fail "直接改 main 的 commit 被推上去了，代表分支保護還沒生效。"
      hint "確認 Ruleset 的 Enforcement status 是 Active，而且勾選了 Require a pull request before merging。"
    else pass "直接改 main 的 commit 沒有被推上去"; fi
    if [ "$(git rev-parse main)" = "$(git rev-parse origin/main)" ]; then pass "本機的 main 已經回到和 GitHub 一樣"
    else fail "本機的 main 還留著那個 commit。"; hint "它還沒 push 出去，可以放心用 git reset --hard origin/main 丟掉"; fi
    if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
      n="$(gh api 'repos/{owner}/{repo}/rulesets' --jq 'length' 2>/dev/null)"
      if [ "${n:-0}" -ge 1 ]; then pass "GitHub 上有 $n 條 ruleset"
      else fail "GitHub 上找不到 ruleset。"; fi
    fi
    finish "之後要改 main，一律開分支、走 PR。第 13 關是選做：practice/levels/13-金鑰外洩.md"
    ;;

  13)
    need_repo; need_started 13
    hook="$(git rev-parse --git-dir)/hooks/pre-commit"
    if [ -f "$hook" ] && grep -q 'pre-commit' "$hook"; then pass "pre-commit 已經啟用"
    else fail "pre-commit 還沒啟用。"; hint "pre-commit install"; fi
    if git ls-files --error-unmatch deploy-key.pem >/dev/null 2>&1; then
      fail "deploy-key.pem 被 Git 追蹤了！"; hint "git rm --cached deploy-key.pem"
    else pass "金鑰沒有進 commit"; fi
    if [ -f deploy-key.pem ]; then
      if git check-ignore -q deploy-key.pem; then pass ".gitignore 已經會忽略 .pem 檔"
      else fail "deploy-key.pem 還沒被 .gitignore 忽略。"; hint "在 .gitignore 加一行 *.pem，然後 commit"; fi
    else pass "金鑰檔已經刪除"; fi
    finish "全部完成！你已經會用 Git 和 GitHub 保護自己的專案了。"
    ;;

  *)
    die "沒有第 $LEVEL 關。關卡編號是 0 到 13。"
    ;;
esac
