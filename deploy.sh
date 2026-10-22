#!/usr/bin/env bash
# TestPilot の GitHub Pages 自動デプロイ用スクリプト
# 使い方: bash deploy.sh [リポジトリ名(例: test-site)]
set -euo pipefail

REPO_OWNER="${GH_OWNER:-user001}"
REPO_NAME="${1:-test-site}"
REMOTE_URL=""

log() { echo "==> $*"; }

# 1) GitHub 認証済みであること
if ! /c/Users/user001/.hermes/workspace/test-site/tools/gh.exe auth status >/dev/null 2>&1; then
  echo "ERROR: GitHubにログインしていません。" >&2
  echo "      ブラウザで https://github.com/login/device を開き、表示されたコードを入力してください。" >&2
  exit 1
fi

# 2) リポジトリが存在しない場合は作成
if ! /c/Users/user001/.hermes/workspace/test-site/tools/gh.exe repo view "$REPO_OWNER/$REPO_NAME" >/dev/null 2>&1; then
  echo "リポジトリ $REPO_OWNER/$REPO_NAME を作成します…"
  /c/Users/user001/.hermes/workspace/test-site/tools/gh.exe repo create "$REPO_OWNER/$REPO_NAME" --public --source=. --push
fi

# 3) ブランチを切り分けてプッシュ
git checkout -b main 2>/dev/null || git checkout main
git add -A
git commit -m "deploy: test site build" || true
git push -u origin main

# 4) GitHub Pages を有効化
gh repo set-default "$REPO_OWNER/$REPO_NAME" >/dev/null 2>&1 || true
gh api "repos/$REPO_OWNER/$REPO_NAME/pages" -X PUT -f "source[branch]=main" -f "source[path]=/" 2>/dev/null || true

echo ""
echo "========================================"
echo " デプロイ完了予定"
echo "  URL: https://<リポジトリ名>.github.io/<リポジトリ名>/"
echo "  (リポジトリ設定で 'gh-pages' または 'main' を指定してください)"
echo "========================================"
