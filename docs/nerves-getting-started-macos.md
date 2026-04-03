# Nerves の開発環境を構築 (macOS)

Nerves には、システム上にいくつかのプログラムが必要です。Erlang、Elixir、ファームウェアイメージをパッケージ化するためのツールなどがこれに含まれます。

## Xcode コマンドライン ツールのインストール

```bash
xcode-select --install
```

## Homebrew のインストール

まだ Homebrew のインストールをされていない方は以下のコマンドでインストールします。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

`brew` コマンド を `$PATH` に追加します。

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 必要なパッケージのインストール

```bash
brew update

# Nerves関連: see https://hexdocs.pm/nerves/installation.html
brew install fwup squashfs coreutils xz pkg-config
```

## mise のインストール

Nerves では、開発ホストで実行されている Erlang バージョンが組み込みターゲット（Raspberry Pi 4 等）の Erlang バージョンと互換性があることが求められます。そのため、十分な粒度でバージョンを管理できるよう mise を使用して Erlang と Elixir のインストールすることをお勧めします。

```bash
brew install mise
```

miseの設定を`~/.zshrc`に追加します。詳細は[公式ドキュメント](https://mise.jdx.dev/getting-started.html)をご参照ください。zsh以外をお使いの場合は公式ドキュメントで読み替えてください。

```bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc
```

## Erlang と Elixir のインストール

既に Homebrew を使用して Erlang と Elixir をインストールしている場合は、今から mise を用いてインストールするバージョンとの衝突を避けるために、それらを事前にアンインストールしておくことをお勧めします。

```bash
brew uninstall elixir
brew uninstall erlang
```

Erlang と Elixir をインストールします。

```bash
mise use -g erlang@28.1.1
mise use -g elixir@1.19.1-otp-28
```

## Nerves 開発ツールのインストール

nerves_bootstrap は、組み込みターゲットに適したクロスコンパイラを使用してコードが適切にコンパイルできる開発環境や新規 Nerves プロジェクト ジェネレーター（`mix nerves.new`コマンド） 提供します。

```bash
mix local.hex
mix local.rebar

mix archive.install hex nerves_bootstrap
```

## Nerves ファームウエアの開発

Nerves ファームウエアの新規プロジェクトを生成する際に使用するコマンドは以下の通りです。

```bash
cd
mix nerves.new hello_nerves
cd hello_nerves
export MIX_TARGET=rpi4
mix deps.get
mix firmware
mix burn
ssh nerves.local
mix upload
```
