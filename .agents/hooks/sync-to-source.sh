#!/usr/bin/env bash
# my-research/current.md の編集を検出して、TRACE_CODE_DIR (コロン区切りで複数可) に
# ai-guide/current-research.md としてコピーする PostToolUse hook。
#
# 設計:
#  - 対象ファイル: my-research/current.md のみ (code-map.md は ai-research-workspace 専用)
#  - 同期先のファイル名は current-research.md にリネーム (ソースコード側で文脈が立つように)
#  - TRACE_CODE_DIR は .claude/settings.local.json で個人ごとに設定

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

[ -z "$FILE_PATH" ] && exit 0

case "$FILE_PATH" in
  */my-research/current.md) ;;
  *) exit 0 ;;
esac

[ -f "$FILE_PATH" ] || exit 0

TARGETS="${TRACE_CODE_DIR:-}"
if [ -z "$TARGETS" ]; then
  echo "[sync-to-source] TRACE_CODE_DIR is not set; skipping" >&2
  exit 0
fi

IFS=':' read -ra DIRS <<< "$TARGETS"
for BASE in "${DIRS[@]}"; do
  [ -d "$BASE" ] || { echo "[sync-to-source] skip missing dir: $BASE" >&2; continue; }
  TARGET_DIR="$BASE/ai-guide"
  TARGET_FILE="$TARGET_DIR/current-research.md"
  mkdir -p "$TARGET_DIR"
  cp "$FILE_PATH" "$TARGET_FILE"
  echo "[sync-to-source] $FILE_PATH -> $TARGET_FILE" >&2
done

exit 0
