#!/usr/bin/env bash
# 開始一個關卡：把專案變成這一關的情境
# 用法：bash practice/start.sh 關卡編號，例如 bash practice/start.sh 2

. "$(dirname "$0")/lib.sh"

LEVEL="$(printf '%s' "${1:-}" | sed 's/^0*//')"
[ -n "$LEVEL" ] || die "請加上關卡編號，例如：bash practice/start.sh 2"

need_repo

case "$LEVEL" in

  2)
    need_commit; need_branch main; need_clean
    remember start-2 "$(git rev-parse HEAD)"
    replace_line style.css '^h1 \{ color: [^;]*; \}$' 'h1 { color: teal; }'
    replace style.css '--accent: #2f5bd3;' '--accent: #0f8a80;'
    say "🤖 AI 助手：我把網頁換成青綠色主題了！"
    next "用 git status 和 git diff 看看 AI 改了什麼，確認沒問題就 commit。"
    ;;

  3)
    need_commit; need_branch main; need_clean
    remember start-3 "$(git rev-parse HEAD)"
    OLD="代辦" NEW="待辦" perl -pi -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/g' index.html
    cat >> app.js <<'JS'

// 按 Esc 可以清空輸入框
input.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') input.value = '';
});
JS
    replace style.css $'  gap: 8px;\n  margin: 24px 0 0;' $'  gap: 12px;\n  margin: 24px 0 0;'
    say "🤖 AI 助手：我一次幫你做了三件事：修好標題錯字、加上 Esc 清空輸入框、把清單間距拉開。"
    next "用 git status 看看改了哪些檔案，把三件事拆成三個 commit。"
    ;;

  4)
    need_commit; need_branch main; need_clean
    remember start-4 "$(git rev-parse HEAD)"
    replace app.js 'function addTodo(text) {' 'function addTodo(text {'
    cat >> style.css <<'CSS'

body {
  transform: rotate(-2deg);
  font-family: "Comic Sans MS", cursive;
}
CSS
    say "🤖 AI 助手：我重構了一下程式碼，應該會更好用！"
    next "打開 index.html 看看網頁變成什麼樣子，再用 git diff 找出 AI 改了什麼。"
    ;;

  5)
    need_commit; need_branch main; need_clean
    remember start-5 "$(git rev-parse HEAD)"
    replace app.js '`還有 ${left} 件事沒完成`' '`還有 ${left} 件事沒完成，已完成 ${todos.length - left} 件`'
    cat > ai-notes.md <<'MD'
# AI 工作筆記

- 使用者要求：在清單下方顯示已完成的數量
- 修改了 app.js 的 render 函式
- 這份筆記是 AI 自己留的，不需要放進專案
MD
    git add app.js ai-notes.md
    say "🤖 AI 助手：我加上「已完成幾件」的統計，順手把我的工作筆記 ai-notes.md 也 add 進去了。"
    next "用 git status 看看暫存區裡有什麼。只有 app.js 該存進 commit。"
    ;;

  6)
    need_commit; need_branch main; need_clean
    remember start-6 "$(git rev-parse HEAD)"
    remember before-6 "$(git rev-parse HEAD:app.js)"
    replace app.js 'todos = todos.filter((t) => t.id !== id);' 'todos = todos.filter((t) => t.id === id);'
    as_ai commit -q -am "AI：重構刪除功能"
    remember bug-6 "$(git rev-parse HEAD)"
    say "🤖 AI 助手：我重構了刪除功能，也幫你 commit 好了！"
    next "新增三個待辦事項，刪掉其中一個，看看發生什麼事。再用 git log 和 git show 找出問題。"
    ;;

  7)
    need_commit
    if [ "$(branch)" = "main" ]; then
      die "這一關要在新的分支上進行。請先執行：git switch -c feature-search，再執行一次這個指令。"
    fi
    need_branch feature-search; need_clean
    remember start-7 "$(git rev-parse HEAD)"
    replace index.html $'    </form>\n' $'    </form>\n    <label class="visually-hidden" for="search-input">搜尋待辦事項</label>\n    <input id="search-input" class="search" type="search" placeholder="搜尋待辦事項">\n'
    replace app.js $'const count = document.getElementById(\'todo-count\');\n' $'const count = document.getElementById(\'todo-count\');\nconst search = document.getElementById(\'search-input\');\n'
    replace app.js $'function visibleTodos() {\n  return todos;\n}' $'function visibleTodos() {\n  const keyword = search.value.trim();\n  if (!keyword) return todos;\n  return todos.filter((t) => t.text.includes(keyword));\n}'
    cat >> app.js <<'JS'

// 輸入關鍵字，即時篩選清單
search.addEventListener('input', render);
JS
    cat >> style.css <<'CSS'

.search {
  display: block;
  width: 100%;
  margin-top: 12px;
}
CSS
    say "🤖 AI 助手：我在 feature-search 分支上加好搜尋功能了。"
    next "確認網頁的搜尋可以用，然後 commit。接著切回 main，看看搜尋框還在不在。"
    ;;

  8)
    need_commit; need_branch main; need_clean
    has_branch feature-color && die "已經有 feature-color 分支了。如果想重來，先執行 git branch -D feature-color。"
    remember start-8 "$(git rev-parse HEAD)"
    git switch -q -c feature-color
    replace_line style.css '^h1 \{ color: [^;]*; \}$' 'h1 { color: purple; }'
    as_ai commit -q -am "AI：標題改成紫色"
    remember theirs-8 "$(git rev-parse HEAD)"
    git switch -q main
    replace_line style.css '^h1 \{ color: [^;]*; \}$' 'h1 { color: darkgreen; }'
    as_mate commit -q -am "標題改成深綠色"
    say "🤖 AI 助手：我在 feature-color 分支把標題改成紫色了。"
    say "👤 同事小林：我剛剛在 main 把標題改成深綠色。"
    next "你現在在 main 上。執行 git merge feature-color，把 AI 的分支合併進來。"
    ;;

  11)
    need_commit
    if [ "$(branch)" = "main" ]; then
      die "這一關要在新的分支上進行。請先執行 git pull，再執行 git switch -c feature-dark-mode。"
    fi
    need_branch feature-dark-mode; need_clean
    remember start-11 "$(git rev-parse HEAD)"
    cat >> style.css <<'CSS'

/* 深色模式：跟著電腦的設定自動切換 */
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #141a24;
    --card: #1e2633;
    --ink: #e6ebf2;
    --muted: #9aa7ba;
    --line: #2f3a4b;
    --accent: #7aa2ff;
    --accent-ink: #141a24;
  }

  h1 { color: #9db8ff; }
}
CSS
    say "🤖 AI 助手：我加好深色模式了，會跟著電腦的設定自動切換。"
    next "commit 之後，用 git push -u origin feature-dark-mode 推上 GitHub，然後開一個 Pull Request。"
    ;;

  12)
    need_commit; need_branch main; need_clean
    git fetch -q origin || die "連不上 GitHub。請確認第 09 關已經完成。"
    [ "$(git rev-parse main)" = "$(git rev-parse origin/main)" ] \
      || die "本機的 main 和 GitHub 上的不一樣。請先執行 git pull。"
    remember start-12 "$(git rev-parse HEAD)"
    replace index.html '<p class="subtitle">' '<p class="subtitle">（直接改 main 試試看）'
    git commit -q -am "直接在 main 上修改副標題"
    remember direct-12 "$(git rev-parse HEAD)"
    say "我幫你在 main 上直接做了一個 commit。"
    next "設定好分支保護之後，執行 git push，看看會發生什麼事。"
    ;;

  13)
    need_commit; need_clean
    remember start-13 "$(git rev-parse HEAD)"
    {
      printf '%s\n' "-----BEGIN RSA PRIV""ATE KEY-----"
      printf '%s\n' "這是練習用的假金鑰，不能拿來登入任何地方"
      printf '%s\n' "-----END RSA PRIV""ATE KEY-----"
    } > deploy-key.pem
    say "🤖 AI 助手：我幫你準備好部署用的金鑰 deploy-key.pem 了，記得一起 commit！"
    next "先執行 pre-commit install，再試著 git add deploy-key.pem 並 commit。"
    ;;

  1|9|10)
    say "第 $LEVEL 關不需要準備情境，直接照著關卡說明操作就好。"
    say "說明在 practice/levels/ 資料夾裡。"
    ;;

  *)
    die "沒有第 $LEVEL 關。關卡編號是 1 到 13。"
    ;;
esac
