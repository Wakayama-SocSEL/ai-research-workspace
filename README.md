# ai-research-workspace

研究・論文執筆・文献管理を Claude Code と連携して行うワークスペーステンプレート。

## 概要

論文 PDF の取り込み → 文献 wiki の構築 → LaTeX 論文執筆を、Claude Code の skill で自動化・半自動化する。

## セットアップ

wiki の閲覧・編集だけなら追加ツールは不要。
論文をローカルでビルド・校正する場合は [paper/SETUP.md](paper/SETUP.md) を参照。

## ディレクトリ構成

```
ai-research-workspace/
├── .agents/skills/        # Claude Code skill (自動検出)
├── ai-guide/              # AI 向けガイド (LaTeX 規約等)
│
├── paper/                 # LaTeX 論文本体 (venue 別)
│   ├── common/            # 共有素材 (refs.bib, macros.sty)
│   └── <venue>-<year>/    # 各論文 (独立 git リポジトリ可)
│
├── my-research/           # 研究ストーリー (主張ベース)
├── wiki/                  # 文献 wiki (事実ベース)
│   ├── papers/            # 論文要約ページ
│   └── concepts/          # 概念ページ
│
├── raw/papers/            # 論文 PDF 原本
├── slidegen/drafts/       # ゼミ・輪講用スライド draft (markdown)
└── log.md                 # 作業履歴
```

### 共有 vs 個人

| 共有 (git tracked) | 個人 (gitignored) |
|---|---|
| skills, ai-guide/, 設定ファイル | my-research/ |
| paper/README.md, ai-guide/venues.md | paper/common/, wiki/papers/*, wiki/concepts/* |
| .gitkeep (ディレクトリ構造) | raw/papers/*.pdf, log.md, slidegen/drafts/* |

clone すると**ディレクトリ構造だけ**が手に入り、中身は各自で育てる。

## Skills

`.agents/skills/` に配置。Claude Code が自動検出する。

| skill | 呼び出し例 |
|---|---|
| **ingest-paper** | `/ingest-paper all` — PDF を wiki に取り込み |
| **query-wiki** | `/query-wiki Hydra の pruning とは？` |
| **write-paper** | `/write-paper §3 手法` |
| **lint-wiki** | `/lint-wiki` — リンク切れ・矛盾の検出 |
| **trace-to-source** | `/trace-to-source C1 型条件` |
| **draft-slides** | `/draft-slides hydra.pdf` — PDF からゼミ・輪講用スライド draft を生成 |

## 2 層の知識構造

| 層 | 性質 | 内容 |
|---|---|---|
| **wiki/** | 事実ベース | 「この論文はこう主張している」 |
| **my-research/** | 主張ベース | 「自分はこう提案する」 |

wiki は研究テーマが変わっても資産として残る。my-research はテーマと共に進化する。

## 論文ディレクトリの運用

各論文は `paper/<venue>-<year>/` に独立した git リポジトリとして置ける (Overleaf 連携等)。詳細は [paper/README.md](paper/README.md) を参照。
