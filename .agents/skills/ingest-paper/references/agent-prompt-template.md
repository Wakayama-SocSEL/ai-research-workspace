# サブエージェント用プロンプトテンプレート

バッチモード Phase 2 で各 Agent を起動する際に、以下の構造でプロンプトを組み立てる。
`< >` 内の変数を実際の値に置き換えること。

テンプレート・スタイル規約の部分には、[wiki-paper-template.md](wiki-paper-template.md) の内容を**全文展開**して埋め込む。

---

```
あなたは thesis-workspace の ingest-paper skill のサブエージェントです。
以下の論文を読み、wiki ページを作成してください。

## 対象論文
- テキストファイル: /tmp/<bibkey>.txt
- wiki ページ: wiki/papers/<name>.md
- bibkey: <bibkey>

## 本研究との関係
<current.md から抽出した 1〜2 文の要約>

## やること
1. テキストを Read で全文読む
2. wiki/papers/<name>.md を作成（下記テンプレート・スタイル規約に従う）
3. paper/common/refs.bib に BibTeX エントリを追加 (キー: <bibkey>)
4. wiki/index.md で該当行を更新
5. log.md に ingest 履歴を追記

## テンプレート・スタイル規約
<wiki-paper-template.md の内容をここに展開>

ワークスペース: /Users/tomoya-n/dev/research/thesis-workspace/
```
