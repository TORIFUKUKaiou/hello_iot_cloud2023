# Nerves の開発環境を構築 (Ubuntu 24.04 LTS)

Nerves には、システム上にいくつかのプログラムが必要です。Erlang、Elixir、ファームウェアイメージをパッケージ化するためのツールなどがこれに含まれます。

## 必要なパッケージのインストール

```bash
sudo apt update

# Erlang関連: see https://github.com/asdf-vm/asdf-erlang
sudo apt install build-essential autoconf m4 libncurses5-dev libwxgtk3.2-dev libwxgtk-webview3.2-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk

# Nerves関連: see https://hexdocs.pm/nerves/installation.html
sudo apt install build-essential automake autoconf git squashfs-tools ssh-askpass pkg-config curl libmnl-dev
```

## asdf のインストール

Nerves では、開発ホストで実行されている Erlang バージョンが組み込みターゲット（Raspberry Pi 4 等）の Erlang バージョンと互換性があることが求められます。そのため、十分な粒度でバージョンを管理できるよう asdf を使用して Erlang と Elixir のインストールすることをお勧めします。

```bash
cd
sudo apt install wget tar
wget https://github.com/asdf-vm/asdf/releases/download/v0.17.0/asdf-v0.17.0-linux-amd64.tar.gz
mkdir -p ~/bin
tar -xzvf asdf-v0.17.0-linux-amd64.tar.gz -C ~/bin/
echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

`asdf-v0.17.0-linux-amd64.tar.gz`は、`asdf-v0.17.0-linux-386.tar.gz`もしくは`asdf-v0.17.0-linux-arm64.tar.gz`で読み替える必要があるかもしれません。

asdfの設定を`~/.bashrc`に追加します。詳細は[公式ドキュメント](https://asdf-vm.com/ja-jp/guide/getting-started.html)をご参照ください。Ubuntu 24.04では以下の手順を実行します。

```bash
echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.bashrc
echo '. <(asdf completion bash)' >> ~/.bashrc
source ~/.bashrc
```

## Erlang と Elixir のインストール

既に apt を使用して Erlang と Elixir をインストールしている場合は、今から asdf を用いてインストールするバージョンとの衝突を避けるために、それらを事前にアンインストールしておくことをお勧めします。

```bash
sudo apt remove elixir
sudo apt remove erlang erlang-dev
```

Erlang と Elixir をインストールします。

```bash
asdf plugin add erlang
asdf plugin add elixir

asdf install erlang 27.3.3
asdf install elixir 1.18.3-otp-27
asdf set -u erlang 27.3.3
asdf set -u elixir 1.18.3-otp-27
```

## fwup のインストール

```bash
cd
curl -fLO https://github.com/fhunleth/fwup/releases/download/v1.12.0/fwup_1.12.0_amd64.deb
sudo dpkg -i fwup_1.12.0_amd64.deb
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
