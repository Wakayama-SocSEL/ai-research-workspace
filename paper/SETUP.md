# ローカル論文執筆環境のセットアップ

論文をローカルでビルド・執筆するために必要な環境構築手順。

## 1. LaTeX ディストリビューション

### macOS

[MacTeX](https://www.tug.org/mactex/) をインストールする。

```bash
brew install --cask mactex
```

インストール後、シェルを再起動して `latexmk` が使えることを確認:

```bash
latexmk --version
```

### Linux (Ubuntu/Debian)

```bash
sudo apt-get install texlive-full latexmk
```

## 2. textlint (校正ツール)

### 推奨: mise を使う方法

[mise](https://mise.jdx.dev/) で `paper/.mise.toml` に定義された Node.js・pnpm を一括セットアップする。

miseの環境構築（miseの環境がある人はスキップ可能）
```bash
brew install mise.     # miseのインストール
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc.       # PATHをアクティベート
mise doctor            # mise環境がセットアップされていることを確認
```

miseで必要なパッケージをインストール
```bash
cd paper/
mise install           # Node.js 22 + pnpm 10
mise run setup         # pnpm install (textlint + prh)
```

### 手動セットアップ

Node.js 22 と pnpm 10 を個別にインストールしたうえで:

```bash
cd paper/
pnpm install
```

### 使い方

リント・フォーマット
```bash
cd paper/
pnpm lint              # .tex ファイルの校正チェック
pnpm fix               # 自動修正可能なものを修正
```

コンパイル
VSCodeの左側にあるタブから緑の三角のボタンをクリックしてコンパイル
