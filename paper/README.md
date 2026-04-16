# paper/

LaTeX 論文本体を置くディレクトリ．

## 命名規則

論文ごとに `<venue>-<year>/` のサブディレクトリを作成．

例:
- `fse-2026/`
- `oopsla-2026/`
- `icse-2027/`

投稿先未定の場合は `wip-<short-name>/` でスタートし，決まったらリネーム．

## サブディレクトリの標準構成

```
<venue>-<year>/
├── main.tex
├── sections/
│   ├── 01_introduction.tex
│   ├── 02_background.tex
│   ├── 03_method.tex
│   ├── 04_evaluation.tex
│   ├── 05_related_work.tex
│   └── 06_conclusion.tex
├── figures/
├── tables/
├── refs.bib → ../common/refs.bib   # symlink
└── README.md                        # status / deadline / target venue
```

## 共有資産

- `common/refs.bib`: 全論文で共有する文献データベース．`ingest-paper` skill が追記
- `common/macros.sty`: 共有マクロ

各論文では以下のように使う：

```latex
\bibliography{../common/refs}
\usepackage{../common/macros}
```

## Overleaf 連携

各論文ディレクトリは Overleaf (GitHub 連携) の独立リポジトリとして運用できる。

```bash
cd paper/
git clone git@github.com:<org>/<paper-repo>.git ses-2026
```

ローカルで編集 → `git push` → Overleaf に反映。逆も同様。

`common/refs.bib` はビルド時にコピーする (.latexmkrc で設定)。

### TODO

- [ ] Overleaf プロジェクトの作成と GitHub 連携の設定
- [ ] `.latexmkrc` で `common/refs.bib` の自動コピーを設定
- [ ] 論文テンプレート (SES 形式) の配置

## 論文を新規作成するときの手順

1. `paper/<venue>-<year>/` を作成
2. 上記標準構成に従ってファイルを配置
3. `README.md` に status / deadline / target venue / based-on-version を記載
4. `write-paper` skill で節を書き始める
