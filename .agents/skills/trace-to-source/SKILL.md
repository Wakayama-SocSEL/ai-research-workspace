---
name: trace-to-source
description: 論文概念 ↔ 実装コードの双方向逆引き。論文執筆中に「この§の実装はどこ？」、実装中に「このコードはどの§に対応？」を高速解決する
disable-model-invocation: true
argument-hint: /trace-to-source <概念名 or ファイルパス>
---

# trace-to-source スキル

**論文 ↔ コード**の双方向マッピングを引くスキル。

## 前提チェック

!`[ -z "$TRACE_CODE_DIR" ] && echo "⚠ TRACE_CODE_DIR が未設定です。.claude/settings.local.json の env に設定してください" || echo "✓ コードディレクトリ: $TRACE_CODE_DIR"`
!`[ -z "$TRACE_PAPER_DIR" ] && echo "⚠ TRACE_PAPER_DIR が未設定です。.claude/settings.local.json の env に設定してください" || echo "✓ 論文ディレクトリ: $TRACE_PAPER_DIR"`

⚠ が表示された場合は処理を中断し、ユーザーに設定を案内する。

## 対象パス

- **論文側**: `$TRACE_PAPER_DIR/my-research/code-map.md`, `$TRACE_PAPER_DIR/my-research/current.md`, `$TRACE_PAPER_DIR/paper/<venue>-<year>/sections/*.tex`
- **コード側**: `$TRACE_CODE_DIR/`

workspace 内からも、コードリポジトリ内からも呼べる。環境変数の絶対パスで解決する。

## 引数のパターン

### パターン A: 概念名 → コード位置（順引き）

例: `/trace-to-source 動的等価性チェッカ`

1. `$TRACE_PAPER_DIR/my-research/code-map.md` を Read し、対応する節エントリを探す
2. エントリがあればリストされているファイルを Read してユーザーに提示
3. エントリがなければ `$TRACE_CODE_DIR/` 全体を Grep で検索：
   - 関数名・クラス名・識別子としてのマッチ
   - コメント内の日本語概念名マッチ
   - `# PAPER:` マーカー付きコメントのマッチ
4. 結果を `file:line` 形式で返す

### パターン B: コードファイルパス → 論文節（逆引き）

例: `/trace-to-source equiv/vm_runner.py`

1. 該当ファイルを Read し、先頭コメントに `# PAPER: §X.Y` マーカーがあるか確認
2. マーカーがあれば該当節を `$TRACE_PAPER_DIR/my-research/current.md` から Read して提示
3. マーカーがなければ `$TRACE_PAPER_DIR/my-research/code-map.md` を逆引き Grep
4. どちらにも無ければ `$TRACE_PAPER_DIR/paper/<venue>-<year>/sections/*.tex` を関数名 / クラス名で Grep

## 出力形式

```markdown
## <クエリ>

### 論文側
- my-research/current.md §4 C-2 動的等価性チェッカ
- paper/fse-2026/sections/03_method.tex:85

### 実装側
- equiv/vm_runner.py:12 (class VmRunner)
- equiv/oracles/live_output.py:8

### 備考
- code-map.md の更新が必要な場合はここで提案
```

## code-map.md の更新提案

skill を呼んでいる最中に「このファイルは code-map に未登録だが追加すべき」と判断したら、ユーザーに提案してから追記する（勝手に追記しない）。

## `# PAPER:` マーカー運用

コード側の推奨コメント規約：

```python
# PAPER: §4 C-2 動的等価性チェッカ
class VmRunner:
    ...
```

このマーカーがあるとパターン B の逆引きが O(1) になる。推奨だが必須ではない。

## 注意事項

- **コード側のリポジトリを編集しない**。あくまで読み取り専用
- クロスリポジトリのため、Grep は絶対パスを使う
- コード位置は**行番号必須**（Claude Code でクリック可能にする）
- 見つからなかった場合は「未実装」「マーカー未設定」のどちらか明示
