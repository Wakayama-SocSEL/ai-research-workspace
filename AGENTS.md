# thesis-workspace

研究・論文執筆・文献管理を1つの作業ディレクトリで完結させるワークスペース。
**ローカル専用** — GitHub には push しない（論文 PDF は著作物のため）。

---

## ディレクトリ構成

```
thesis-workspace/
├── AGENTS.md                  # このファイル（実体）
├── CLAUDE.md                  # → AGENTS.md (symlink)
│
├── .textlintrc, prh.yml, package.json, node_modules/
├── .vscode/                   # LaTeX-Workshop + textlint 設定
│
├── paper/                     # LaTeX 論文本体（venue 別）
│   ├── common/{refs.bib, macros.sty}
│   └── <venue>-<year>/        # 投稿先決定後に作成
│
├── my-research/               # 研究ストーリー（主張ベース、流動的）
│   ├── README.md
│   ├── current.md             # 現行版
│   ├── versions/vN_YYYY-MM-DD.md
│   ├── drafts/                # 節単位の作業中ドラフト
│   ├── open-questions.md
│   └── code-map.md            # §章 ↔ MB-scanner モジュール対応
│
├── wiki/                      # llm-wiki（事実ベース、安定）
│   ├── index.md               # 全ページ索引
│   ├── papers/                # 論文要約ページ
│   └── concepts/              # ドメイン中立な概念ページ
│
├── raw/papers/                # PDF 原本（gitignored）
└── log.md                     # ingest 履歴
```

---

## 2層の知識構造

| | 性質 | 更新頻度 | 内容 |
|---|---|---|---|
| **wiki/** | 事実ベース | 論文追加時 | 「この論文はこう主張している」「この概念はこう定義される」 |
| **my-research/** | 主張ベース | 頻繁 | 「自分はこう提案する」「現在の問いはこれ」 |

wiki は研究テーマが変わっても資産として残る。my-research はテーマと共に進化する。
