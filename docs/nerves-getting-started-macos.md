# Nerves の開発環境を構築 (MacOS)

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

# Erlang関連: see https://github.com/asdf-vm/asdf-erlang
brew install wxwidgets libxslt fop openjdk

# Nerves関連: see https://hexdocs.pm/nerves/installation.html
brew install fwup squashfs coreutils xz pkg-config
```

## ASDF のインストール

Nerves では、開発ホストで実行されている Erlang バージョンが組み込みターゲット（Raspberry Pi 4 等）の Erlang バージョンと互換性があることが求められます。そのため、十分な粒度でバージョンを管理できるよう ASDF を使用して Erlang と Elixir のインストールすることをお勧めします。

```bash
brew install asdf
```

`asdf.sh`スクリプトを`~/.zshrc`に追加します。詳細は[公式ドキュメント](https://asdf-vm.com/ja-jp/guide/getting-started.html)をご参照ください。

```bash
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
source ${ZDOTDIR:-~}/.zshrc
```

## Erlang と Elixir のインストール

既に Homebrew を使用して Erlang と Elixir をインストールしている場合は、今から ASDF を用いてインストールするバージョンとの衝突を避けるために、それらを事前にアンインストールしておくことをお勧めします。

```bash
brew uninstall elixir
brew uninstall erlang
```

Erlang と Elixir をインストールします。

```bash
asdf plugin-add erlang
asdf plugin-add elixir

asdf install erlang 27.0.1
asdf install elixir 1.17.2-otp-27

asdf global erlang 27.0.1
asdf global elixir 1.17.2-otp-27
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
