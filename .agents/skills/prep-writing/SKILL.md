---
name: prep-writing
description: 論文執筆前の準備．current.md と wiki を照合し，未 ingest 論文の洗い出し・優先順位付け・一括 ingest を行う
disable-model-invocation: true
argument-hint: /prep-writing
---

# prep-writing スキル

論文執筆フェーズの最初に 1 回実行する．current.md の参考文献と wiki の状態を照合し，執筆に必要な準備を整える．

## 実行手順

### 1. 引用棚卸し

`my-research/current.md` の参考文献節と `wiki/index.md` を照合し，以下を報告:

1. **current.md で参照しているが wiki/papers/ にページがない論文** (= 未 ingest) の一覧
2. 各論文について:
   - PDF が `raw/papers/` にあるか
   - なければ入手方法 (arxiv / ACM DL / 著者サイト)
   - 論文のどの節で引用するか (§2 背景 / §3 手法 / §7 関連研究)
3. **wiki/papers/ にあるが current.md で参照していない論文** (= 不要かもしれない) の一覧
4. **ingest 推奨順序** (論文の節順: §2 背景 → §3 手法 → §7 関連研究)

### 2. 未 ingest 論文の一括処理

ユーザーが「ingest して」と指示したら，推奨順序に従って `ingest-paper` skill を順次呼び出す．

PDF がないものは Web 検索で abstract を取得し，abstract ベースで簡易 wiki ページを作成する (「要精読」タグ付き)．

### 3. wiki/index.md の更新

ingest 完了後，`wiki/index.md` の該当セクション (本論文で直接使う / 将来の論文で使える / 汎用知識) に追記．

### 4. refs.bib の確認

`paper/common/refs.bib` に全参考文献のエントリがあるか確認．不足分を追加．

## 注意事項

- wiki/papers/ には**事実のみ**を書く．current.md との関係は wiki に書かない
- current.md との関係は `wiki/index.md` のセクション分けで表現する
- `ingest-paper` skill の執筆スタイル規約に従う (日常語の一行サマリー，具体例，用語ガイド)
