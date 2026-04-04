# Nerves の開発環境を構築 (Ubuntu 24.04 LTS)

Nerves には、システム上にいくつかのプログラムが必要です。Erlang、Elixir、ファームウェアイメージをパッケージ化するためのツールなどがこれに含まれます。

## 必要なパッケージのインストール

```bash
sudo apt update

# Nerves関連: see https://hexdocs.pm/nerves/installation.html
sudo apt install build-essential automake autoconf git squashfs-tools ssh-askpass pkg-config curl libmnl-dev
```

## mise のインストール

Nerves では、開発ホストで実行されている Erlang バージョンが組み込みターゲット（Raspberry Pi 4 等）の Erlang バージョンと互換性があることが求められます。そのため、十分な粒度でバージョンを管理できるよう mise を使用して Erlang と Elixir のインストールすることをお勧めします。

```bash
curl https://mise.run | sh

~/.local/bin/mise --version
```


miseの設定を`~/.bashrc`に追加します。詳細は[公式ドキュメント](https://mise.jdx.dev/getting-started.html)をご参照ください。Ubuntu 24.04では以下の手順を実行します。bash以外をお使いの方は公式ドキュメントをご参照ください。

```bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
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

## fwup のインストール

```bash
cd
curl -fLO https://github.com/fwup-home/fwup/releases/download/v1.15.0/fwup_1.15.0_amd64.deb
sudo dpkg -i fwup_1.15.0_amd64.deb
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
