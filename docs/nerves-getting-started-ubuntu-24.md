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

## fwup のインストール

```bash
cd
curl -fLO https://github.com/fhunleth/fwup/releases/download/v1.10.2/fwup_1.10.2_amd64.deb
sudo dpkg -i fwup_1.10.2_amd64.deb
```

## ASDF のインストール

Nerves では、開発ホストで実行されている Erlang バージョンが組み込みターゲット（Raspberry Pi 4 等）の Erlang バージョンと互換性があることが求められます。そのため、十分な粒度でバージョンを管理できるよう ASDF を使用して Erlang と Elixir のインストールすることをお勧めします。

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
```

`asdf.sh`スクリプトを`~/.bashrc`に追加します。詳細は[公式ドキュメント](https://asdf-vm.com/ja-jp/guide/getting-started.html)をご参照ください。

```bash
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
source ~/.bashrc
```

## Erlang と Elixir のインストール

既に apt を使用して Erlang と Elixir をインストールしている場合は、今から ASDF を用いてインストールするバージョンとの衝突を避けるために、それらを事前にアンインストールしておくことをお勧めします。

```bash
sudo apt remove elixir
sudo apt remove erlang erlang-dev
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
