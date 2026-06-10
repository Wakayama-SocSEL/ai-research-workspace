---
name: manage-research-versions
description: my-research/current.md のバージョン管理手順。current.md を大幅に改訂・上書きする前のスナップショット凍結と、versions/ ディレクトリの整理を行う。「current.md を更新したい」「研究方針を見直す」「質疑・指導教員のフィードバックを反映する」「方針転換 (pivot) する」「versions/ を整理する」「版履歴を更新する」など、研究計画ファイルの改訂・履歴管理に関わる文脈では、明示的に呼ばれなくても必ずこのスキルを最初に使うこと。特に current.md を Edit/Write で書き換える作業を始める前に発火させる。my-research/ は gitignore されており git 履歴が残らないため、この手順を飛ばすと旧版が失われる。
---

# manage-research-versions スキル

`my-research/current.md` (研究ストーリーの現行版) のバージョン管理を行うスキル。

## 前提: なぜこの手順が必要か

`.gitignore` で `my-research/*` が除外されているため、**current.md には git 履歴が一切残らない**。`versions/` のスナップショットが唯一の履歴である。凍結せずに上書きすると旧版は失われる (v8 改訂時に実際に発生し、会話ログから復元した)。

## 改訂を始める前の判定

current.md への変更を、まず次の 2 つに分類する:

| 種別 | 例 | 手順 |
|---|---|---|
| **マイナー改訂** | 誤記修正、1 節の追記、数値の更新、リンク修正 | そのまま current.md を直接編集してよい |
| **メジャー改訂 (新版)** | 下記「新版を切る判断基準」のいずれかに該当 | **凍結 → 改訂** の手順に従う |

### 新版を切る判断基準 (`my-research/README.md` と同期)

- RQ の差し替え
- 技術貢献の追加 / 削除 / 再編 (パイプライン段の新設を含む)
- 評価計画の再設計
- 想定投稿先 venue の変更
- 発表・指導教員フィードバックの反映で複数節が書き換わる規模の改訂

迷ったら凍結する。スナップショットは安価だが、失われた版は復元できない。

## メジャー改訂の手順

1. **凍結 (上書きの前に必ず行う)**

   ```bash
   cp my-research/current.md my-research/versions/v<N>_<YYYY-MM-DD>.md
   ```

   - `<N>` = 現行版の版番号 (current.md の frontmatter `status:` で確認)
   - `<YYYY-MM-DD>` = **その版が書かれた日付** (current.md の frontmatter `date:`)。凍結作業日ではない
   - 凍結したファイルは以後編集しない。frontmatter に `frozen: <凍結日>` を 1 行追記してよい

2. **current.md を改訂**し、frontmatter を更新する:

   ```yaml
   date: <改訂日>
   status: 第 <N+1> 版 (<改訂の契機を一言で>)
   goal: <現時点の目標>
   supersedes: versions/v<N>_<YYYY-MM-DD>.md   # 必ず手順 1 で凍結した実在ファイルを指す
   ```

3. **`my-research/README.md` の「版履歴」表に 1 行追加**する (版番号 / 日付 / 要旨)。

4. 改訂で生まれた未決の論点は `my-research/open-questions.md` に登録する。

## versions/ の整理規則

`versions/` に置いてよいのは次の 2 種類だけ:

- `v<N>_<YYYY-MM-DD>.md` — current.md のスナップショット (凍結済み・編集禁止)
- 版履歴に付随するアーカイブ (例: `v1-v6_ideas_archive_*.md` = 不採用アイデアの保存)

それ以外が紛れ込んでいたら適切な場所へ移す:

| 種類 | 行き先 |
|---|---|
| 文献サーベイ報告 | `my-research/surveys/` |
| 節単位の作業中ドラフト | `my-research/drafts/` |
| 論文要約・概念整理 | `wiki/` (事実ベースはこちら) |

## 整合性チェック (versions/ を触ったとき・求められたとき)

- current.md の `supersedes:` が実在するファイルを指しているか
- README の版履歴表と versions/ の実ファイルが一致しているか
- 凍結漏れの版がないか (status の版番号と versions/ の最大 N の差を見る)
