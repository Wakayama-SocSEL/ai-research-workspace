#!/usr/bin/env bash
set -euo pipefail

SETTINGS=".claude/settings.local.json"
EXAMPLE=".claude/settings.local.json.example"

if [ -f "$SETTINGS" ]; then
  echo "✓ $SETTINGS は既に存在します。スキップします。"
  echo "  リセットするには $SETTINGS を削除してから再実行してください。"
  exit 0
fi

echo "=== thesis-workspace セットアップ ==="
echo ""
echo "スキル (trace-to-source 等) が参照するパスを設定します。"
echo ""

read -rp "解析対象のソースコードリポジトリの絶対パス: " code_dir
read -rp "この thesis-workspace の絶対パス [$(pwd)]: " paper_dir
paper_dir="${paper_dir:-$(pwd)}"

# パス存在チェック
for dir in "$code_dir" "$paper_dir"; do
  if [ ! -d "$dir" ]; then
    echo "⚠ ディレクトリが見つかりません: $dir"
    exit 1
  fi
done

cat > "$SETTINGS" <<EOF
{
  "permissions": {
    "allow": [
      "WebSearch"
    ]
  },
  "env": {
    "TRACE_CODE_DIR": "$code_dir",
    "TRACE_PAPER_DIR": "$paper_dir"
  }
}
EOF

echo ""
echo "✓ $SETTINGS を作成しました:"
cat "$SETTINGS"
