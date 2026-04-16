---
name: ingest-paper
description: raw/papers/ にある論文 PDF を読み、wiki/papers/ に要約ページを作成し、wiki/concepts/ を更新し、log.md に履歴を追記する
disable-model-invocation: true
argument-hint: /ingest-paper <pdf-filename | "all">
---

# ingest-paper スキル

論文を llm-wiki に取り込むスキル。**単体モード**と**バッチモード**がある。

## 前提

- 対象 PDF が `raw/papers/<filename>.pdf` に置かれていること
- `wiki/index.md` / `wiki/papers/` / `wiki/concepts/` が存在すること
- **poppler** がインストール済みであること（`pdftotext` コマンドに必要。`brew install poppler` または `apt-get install poppler-utils`）

## モード判定

| 引数 | モード | 処理 |
|---|---|---|
| 特定のファイル名 | **単体モード** | その 1 本だけ処理 |
| `all`、「全て」、「まだ取り込んでいない全て」等 | **バッチモード** | 未 ingest の全 PDF を並列処理 |

---

## 参照する meta reference

処理前に以下を読む（バッチモードでは Phase 1 で 1 度だけ）:

- **`ai-guide/venues.md`** — venue の Tier 分類
- **`wiki/reference-strategy.md`** — 引用カテゴリと「即追加すべき論文」リスト
- **`my-research/current.md`** — 本研究との関連付け用

---

## 単体モード

引数で指定された 1 本の PDF を処理する。Agent は使わず直接実行する。

### 手順

1. **テキスト抽出**: `pdftotext "raw/papers/<filename>.pdf" "/tmp/<filename>.txt"`
2. **リネーム**: `/tmp/<filename>.txt` の先頭 30 行を読み、第一著者姓・年・短縮名を特定する。命名規則に合致していなければ `mv` でリネームする（命名規則はバッチモード Phase 1-3 と同じ）。**以降は新しいファイル名を使う。**
3. **meta reference の読み込み**: `ai-guide/venues.md`、`wiki/reference-strategy.md`、`my-research/current.md` を読む
4. **wiki ページ作成**: [references/wiki-paper-template.md](references/wiki-paper-template.md) を Read し、テンプレート・スタイル規約に従い `wiki/papers/<name>.md` を作成
5. **refs.bib 追記**: `paper/common/refs.bib` に BibTeX エントリを追加
6. **wiki/index.md 更新**: 該当行を「未 ingest」→ リンクに更新
7. **log.md 追記**: ingest 履歴を追記
8. **concepts 更新**: 関連する `wiki/concepts/` ページを追記・新規作成

---

## バッチモード (3 フェーズ)

### Phase 1: 準備 (逐次)

#### 1-1. 未 ingest PDF の特定

Bash で以下を実行し、未処理の PDF を列挙する:

```bash
# raw/papers/ の PDF 一覧と wiki/papers/ の既存ページを比較
ls raw/papers/*.pdf
ls wiki/papers/*.md
```

wiki/papers/ に対応する .md がない PDF が未 ingest。

#### 1-2. PDF テキスト抽出 (一括)

**Bash で pdftotext を一括実行**する:

```bash
for f in raw/papers/<対象PDF群>; do
  out="/tmp/$(basename "$f" .pdf).txt"
  pdftotext "$f" "$out"
done
```

#### 1-3. PDF リネーム

**Bash で各 PDF の先頭を読み、著者・年を特定してリネーム**する。

手順:
1. 各 /tmp/*.txt の先頭 30 行を Read で読む
2. 第一著者の姓 (小文字)、発表年、短縮名を特定する
3. Bash で `mv` を実行:

```bash
mv "raw/papers/<元の名前>.pdf" "raw/papers/<firstauthor><year><short>.pdf"
```

命名規則: `<第一著者姓小文字><年><短縮名>.pdf`
例: `menendez2017alive-infer.pdf`, `meng2013lase.pdf`, `bader2019getafix.pdf`

**既に命名規則に合致しているファイルはスキップする。**

#### 1-4. meta reference の読み込み

`ai-guide/venues.md`、`wiki/reference-strategy.md`、`my-research/current.md` を読み、以下をメモする:
- 本研究の概要 (1 段落)
- 各 PDF が reference-strategy のどの優先度に該当するか

### Phase 2: 並列 ingest (Agent)

**Agent ツールで各論文を並列処理する。** 各 Agent に以下を渡す:

- 抽出済みテキストのパス (`/tmp/<bibkey>.txt`)
- 作成する wiki ページのパス (`wiki/papers/<name>.md`)
- bibkey
- 本研究との関係の要約 (1〜2 文)
- テンプレートとスタイル規約 ([references/agent-prompt-template.md](references/agent-prompt-template.md) を Read してプロンプトを組み立てる)

各 Agent の責務:
1. テキストを Read で全文読む
2. `wiki/papers/<name>.md` を作成（テンプレート + スタイル規約に従う）
3. `paper/common/refs.bib` に BibTeX エントリを追加
4. `wiki/index.md` で該当行を「未 ingest」→ リンクに更新
5. `log.md` に ingest 履歴を追記

**Agent は `run_in_background: true` で起動し、全て並列実行する。**

### Phase 3: 統合 (逐次、全 Agent 完了後)

#### 3-1. 成果物の検証

```bash
ls wiki/papers/          # 全ページが揃っているか
grep '^@' paper/common/refs.bib  # 全 bib エントリがあるか
grep '未 ingest' wiki/index.md    # 残りがないか
```

#### 3-2. 重複・不整合の修正

- refs.bib の重複エントリを確認・除去
- bibkey と PDF ファイル名の不一致を修正
- wiki/index.md の抜け漏れを補完

#### 3-3. concepts の統合更新

Agent は concepts を更新しないので、ここで一括更新する:
- 各 wiki/papers/*.md の内容を踏まえて、関連する concepts ページを追記
- 新規 concept が必要な場合は作成

#### 3-4. ユーザーに報告

作成・更新したファイル一覧と、次に読むべき候補論文を提示。

---

## references

| ファイル | 内容 | 使うタイミング |
|---|---|---|
| [references/wiki-paper-template.md](references/wiki-paper-template.md) | wiki/papers テンプレート + 執筆スタイル規約 | 単体: ステップ 4 / バッチ: Phase 2 Agent 起動時 |
| [references/agent-prompt-template.md](references/agent-prompt-template.md) | サブエージェント用プロンプト雛形 | バッチ: Phase 2 のみ |

---

## 注意事項

- **事実と主張を混ぜない**: 自分の解釈は wiki ではなく `my-research/drafts/` に書く
- 矛盾を見つけたら隠さず `## 議論` 節で明示する
- PDF 読み込みに失敗したらその論文をスキップし、ユーザーに報告する
- バッチモードでは **concepts の更新は Phase 3 で一括実行**する（Agent 間の競合を避けるため）
