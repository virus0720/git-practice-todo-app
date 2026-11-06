#!/usr/bin/env bash
# 練習腳本的共用函式（不用修改這個檔案）

G=$'\033[32m'; R=$'\033[31m'; Y=$'\033[33m'; C=$'\033[36m'; B=$'\033[1m'; N=$'\033[0m'
FAILED=0
STATE_DIR=""

say()  { printf '%s\n' "$*"; }
pass() { say "${G}✓${N} $*"; }
fail() { say "${R}✗${N} $*"; FAILED=1; }
hint() { say "${Y}提示：${N}$*"; }
next() { say "${C}下一步：${N}$*"; }
die()  { say "${R}✗${N} $*"; exit 1; }

# 確認在 Git 儲存庫裡，並移到專案最上層
need_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
    || die "這裡還不是 Git 儲存庫。請先完成第 01 關（git init），並在專案資料夾裡執行。"
  cd "$(git rev-parse --show-toplevel)" || exit 1
  STATE_DIR="$(git rev-parse --git-dir)/practice"
  mkdir -p "$STATE_DIR"
}

need_commit() {
  git rev-parse -q --verify HEAD >/dev/null || die "還沒有任何 commit。請先完成第 01 關。"
}

branch() { git symbolic-ref --short -q HEAD; }

# 工作區和暫存區都沒有修改（未追蹤的新檔案不算）
is_clean() { [ -z "$(git status --porcelain --untracked-files=no)" ]; }

need_clean() {
  is_clean || die "還有沒處理的修改。先執行 git status 看看，把修改 commit 或用 git restore . 丟掉，再執行一次。"
}

need_branch() {
  [ "$(branch)" = "$1" ] || die "請先切到 $1 分支：git switch $1"
}

has_branch() { git show-ref --verify --quiet "refs/heads/$1"; }

# 用不同的作者身分 commit，模擬 AI 或同事的修改
as_ai()   { git -c user.name="AI 助手" -c user.email="ai@example.com" "$@"; }
as_mate() { git -c user.name="同事小林" -c user.email="mate@example.com" "$@"; }

# 把檔案裡的一段文字換成另一段（字面比對，不用正規表示式）
replace() {
  local file="$1"
  OLD="$2" NEW="$3" perl -0pi -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/' "$file"
  grep -qF -- "$3" "$file" || die "沒辦法修改 $file，裡面找不到預期的內容。這一關需要原本的程式碼，可以用 git log 確認前面的關卡有沒有完成。"
}

# 把整行符合規則的內容換掉
replace_line() {
  local file="$1"
  PAT="$2" NEW="$3" perl -pi -e 's/$ENV{PAT}/$ENV{NEW}/' "$file"
}

remember() { printf '%s' "$2" > "$STATE_DIR/$1"; }
recall()   { cat "$STATE_DIR/$1" 2>/dev/null; }

need_started() {
  [ -n "$(recall "start-$1")" ] || die "還沒開始這一關。請先執行：bash practice/start.sh $1"
}

# 訊息太模糊時回傳 0
vague_msg() {
  local m
  m="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
  case "$m" in
    ""|update|updates|fix|fixed|test|wip|commit|change|changes|修改|更新|改東西|調整|修正|改|測試) return 0 ;;
  esac
  return 1
}

# 從 origin 網址推出 GitHub Pages 網址
pages_url() {
  local url path owner repo
  url="$(git remote get-url origin 2>/dev/null)" || return 1
  path="${url#*github.com[:/]}"
  path="${path%.git}"
  owner="${path%%/*}"
  repo="${path#*/}"
  owner="$(printf '%s' "$owner" | tr '[:upper:]' '[:lower:]')"
  printf 'https://%s.github.io/%s/' "$owner" "$repo"
}

finish() {
  say ""
  if [ "$FAILED" = 0 ]; then
    say "${G}${B}過關！${N}"
    [ -n "${1:-}" ] && next "$1"
  else
    say "還差一點。照上面的提示調整，再執行一次檢查。"
    exit 1
  fi
}
