---
name: lint-wiki
description: wiki の健康診断。孤立ページ・リンク切れ・矛盾・カバレッジ不足を検出する
disable-model-invocation: true
argument-hint: /lint-wiki
---

# lint-wiki スキル

`wiki/` の構造的健全性をチェックするスキル。ingest を繰り返すうちに発生するほつれを発見する。

## 実行手順

### 1. index.md の整合性

- `wiki/index.md` に列挙されているページが実在するか
- `wiki/papers/` と `wiki/concepts/` の実ファイルが index にすべて載っているか

### 2. 孤立ページ検出

- `wiki/papers/*.md` のうち、どの concept からも `[[...]]` 参照されていないページ
- `wiki/concepts/*.md` のうち、どの paper からもタグ / リンクされていないページ

孤立ページは**即削除しない**。ユーザーに提示して判断を仰ぐ。

### 3. リンク切れ検出

`[[wiki/...]]` 形式のリンクを全 wiki から Grep し、リンク先が実在するか検証。

### 4. 矛盾検出

各 concept ページで `## 議論 / 矛盾` 節を探し、未解決の矛盾を一覧化。
ユーザーに「どちらの主張を採用するか、保留するか」を促す。

### 5. カバレッジ不足検出

`my-research/current.md` で言及される概念名（例: `no-escape 述語`, `provenance`, `refuse-based soundness`）を Grep し、それぞれに対応する `wiki/concepts/` ページが存在するか確認。

不足している概念は「my-research で主張しているが wiki に事実ページがない = 論文化時に引用する文献がない」という危険信号。

### 6. bibkey 整合性

`wiki/papers/*.md` の frontmatter の `bibkey` と `paper/common/refs.bib` の BibTeX キーが一致しているか。

### 7. 報告書

以下の形式でレポート：

```markdown
# lint-wiki report [YYYY-MM-DD]

## 索引整合性
- ✅ / ❌

## 孤立ページ
- wiki/papers/xxx.md （どこからも参照なし）

## リンク切れ
- wiki/concepts/yyy.md:42 → [[wiki/papers/zzz]] (not found)

## 未解決の矛盾
- wiki/concepts/equivalence-checking.md §議論: SLACC と EquiBench で ...

## カバレッジ不足
- my-research で言及されているが wiki/concepts/ に存在しない:
  - refuse-based-soundness
  - no-escape-predicate

## bibkey 不整合
- ...

## 推奨アクション
1. ...
2. ...
```

## 注意事項

- **自動修正はしない**。あくまで検出と提案に留める
- 孤立ページの削除はユーザー許可が必要
- 定期的に（月1程度）手動で走らせる運用を想定
