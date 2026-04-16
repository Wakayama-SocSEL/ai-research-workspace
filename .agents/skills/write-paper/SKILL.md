---
name: write-paper
description: LaTeX 論文執筆支援。textlint 連携・研究ストーリー参照・文献引用・コード対応付けを自動化する
disable-model-invocation: true
argument-hint: /write-paper <節や段落の指示>
---

# write-paper スキル

`paper/<venue>-<year>/sections/*.tex` を編集するスキル。
textlint ルールに準拠し、my-research / wiki / MB-scanner コードと一貫性を保つ。

## 対象パス

- **編集対象**: `paper/<venue>-<year>/sections/*.tex`, `paper/<venue>-<year>/main.tex`
- **参照**:
  - `my-research/current.md`（研究ストーリー）
  - `wiki/papers/*.md`（文献事実）
  - `wiki/concepts/*.md`（概念定義）
  - `ai-guide/venues.md`（投稿先候補・引用元 venue の Tier 分類）
  - `wiki/reference-strategy.md`（**引用戦略**: 論文構成 → 引用カテゴリ → 必須論文の対応表）
  - `paper/common/refs.bib`（BibTeX）
  - `MB-scanner/main/`（実装・`trace-to-source` 経由）

## 執筆規約（textlint + prh.yml 由来）

**絶対に守るルール**:

- 句読点: `．` `，`（全角ピリオド・カンマ）。`。` `、` は使わない
- 文体: である調。「ですます」「だ」との混在禁止
- 半角全角の間にスペース: `Web アプリケーション`, `LLM の性能`
- 全角数字禁止: `1つ` ✓ / `１つ` ✗
- 用語統一: `Web`（`WEB` / `ウェブ` 不可）
- 技術英単語はコードスタイルで: `\texttt{for..in}`, `\texttt{parseInt}`

textlint が自動検証するので、編集後は必ず `pnpm run lint` を実行する。

## 実行手順

### 1. 指示の解釈

ユーザーの指示から以下を抽出：

- 編集対象の節（§ 番号 or ファイル名）
- 新規執筆 / 書き直し / 補強 のいずれか
- 参照すべき情報源（論文 / 実装 / 研究ストーリー）

### 2. 情報収集（必要な分だけ）

執筆前に以下を必ず確認：

- **研究ストーリーとの一貫性**: `my-research/current.md` の該当節（§1 モチベーション, §3 RQ, §4 技術貢献 など）を Read
- **文献引用が必要な段落**: `query-wiki` を呼んで事実を拾う → `refs.bib` の bibkey を取得
- **実装を参照する段落**: `trace-to-source` を呼んで `file:line` を取得

勝手に文献を捏造しない。`refs.bib` に無いキーは使わない。

### 3. 編集

`paper/<venue>-<year>/sections/xx.tex` を Edit ツールで編集する。

- 新規段落は必ず「主張 → 根拠 → 引用 → 含意」の順
- 引用は `\cite{key}` で（key は refs.bib から取得済みのもの）
- コード参照は `\texttt{...}` か `\lstinline|...|`
- 数式は `$...$` / `\begin{equation}...\end{equation}`

### 4. textlint 検証

編集後、以下を実行：

```bash
cd ~/dev/research/thesis-workspace && pnpm run lint
```

エラーがあれば修正。`pnpm run fix` で自動修正できるものは修正する。

### 5. ユーザーに報告

- 編集したファイル（`file:line` 付き）
- 追加した引用キー
- textlint 結果
- 未確定事項（要ユーザー判断の箇所）

## よくある執筆パターン

### A. 関連研究の追加

1. **`wiki/reference-strategy.md` §2** で該当する引用カテゴリ (a)〜(o) を特定し，必須論文リストを確認
2. `query-wiki` で該当研究の位置づけを取得
3. `wiki/papers/<name>.md` の §主要貢献を読む
4. `paper/<venue>-<year>/sections/05_related_work.tex` に `\subsection` を追加
5. `refs.bib` に既にあるか確認、無ければ `wiki/papers/<name>.md` の bibkey を追加
6. **未取り込みの必須論文**があれば `ingest-paper` を呼ぶよう提案

### B. 手法節の執筆

1. `my-research/current.md` §4 技術貢献の該当 C-N を Read
2. `trace-to-source` で実装位置を取得
3. アルゴリズム / 図 / 数式を伴う場合は `sections/03_method.tex` + `figures/` に反映
4. `my-research/code-map.md` に「§X.Y ↔ file:line」の対応を追記

### C. 評価節の執筆

1. `my-research/current.md` §6 評価計画を Read
2. 実験結果は `tables/<eval-name>.tex` に分離
3. `sections/04_evaluation.tex` で `\input{tables/...}` して参照

## 注意事項

- **1ターンで 1 節**に集中する（広すぎる編集は精度が落ちる）
- textlint エラーを無視しない
- `\cite{}` のキーは必ず `refs.bib` に存在確認してから書く
- **研究ストーリー（my-research/current.md）と矛盾する記述は絶対に書かない**。矛盾を見つけたら執筆を止めてユーザーに確認する
- 実装の詳細を書く際は `trace-to-source` で実装を見てから書く（記憶で書かない）
