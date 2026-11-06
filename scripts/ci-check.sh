#!/usr/bin/env bash
# CI 檢查：在 Pull Request 和 push 到 main 時，由 GitHub Actions 自動執行
status=0

echo "▶ 檢查衝突標記"
if git grep -nE '^(<<<<<<<|=======|>>>>>>>)' -- '*.html' '*.css' '*.js'; then
  echo "✗ 有檔案還留著衝突標記，請解決衝突後再推上來"
  status=1
else
  echo "✓ 沒有衝突標記"
fi

echo "▶ 檢查金鑰"
if git grep -nE 'BEGIN [A-Z ]*PRIVATE KEY' -- . ':!practice' ':!scripts'; then
  echo "✗ 發現私鑰，請立刻移除並作廢這把金鑰"
  status=1
else
  echo "✓ 沒有發現私鑰"
fi

if git ls-files --error-unmatch .env >/dev/null 2>&1; then
  echo "✗ .env 被 commit 了，裡面的金鑰可能已經外洩"
  status=1
else
  echo "✓ .env 沒有被 commit"
fi

echo "▶ 檢查網頁檔案"
for f in index.html app.js style.css; do
  if [ -f "$f" ]; then echo "✓ $f 存在"; else echo "✗ 找不到 $f"; status=1; fi
done

exit $status
