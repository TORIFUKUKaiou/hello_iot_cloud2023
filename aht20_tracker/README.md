# Aht20Tracker

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix

## Docker Local Usage

```bash
docker compose -f docker-compose-local.yml build
docker compose -f docker-compose-local.yml up -d
docker compose -f docker-compose-local.yml exec web bin/migrate
```

## Docker Image Push

### Windows(WSL 2 Ubuntu)などで

```bash
docker login
docker build -t torifukukaiou/aht20_tracker .
docker push torifukukaiou/aht20_tracker
```

## Usage

```bash
docker compose up
docker compose exec web bin/migrate
```

```
curl -X POST -H "Content-Type: application/json" -d '{"temperature":"21.3", "humidity":"45.3"}' localhost:4000/api/aht20-conditions
```

## Phoenixアップグレード手順

ざっくりいうと全部消して、 `mix phx.new` で新規プロジェクトを作成し、必要なものだけを追加する手順である。なぜこうしているのかというと、 Phoenix のバージョンアップによりデフォルトのまま変更していない箇所も実は変更されている場合があるためである。

### 1. このリポジトリのルートで一度 aht20_tracker を消す

```
rm -rf aht20_tracker
```

### 2. mix phx.new をする（余計なものをあらかじめ作らないようにオプションを指定する）

```
mix phx.new aht20_tracker --binary-id --no-assets --no-html --no-gettext --no-dashboard --no-live
```

### 3. 自身で追加したファイルを元に戻す

全部をもとに戻しているわけではない。
リリース関係のファイルは後述するコマンドで作り直す。

```
git status | grep deleted
git restore aht20_tracker/docker-compose-local.yml
git restore aht20_tracker/docker-compose.yml
git restore aht20_tracker/lib/aht20_tracker/aht20_conditions.ex
git restore aht20_tracker/lib/aht20_tracker_web/controllers/aht20_conditions_controller.ex
git restore aht20_tracker/priv/repo/migrations/20231202183045_set_up_aht20_data_table.exs
git restore aht20_tracker/lib/aht20_tracker/aht20_conditions/aht20_condition.ex
```

### 4. mix deps.get で依存関係を解決する

```
cd aht20_tracker
mix deps.get
```

### 5. リリース関係のファイルをつくる

```
mix phx.gen.release --docker
```

### 6. git diff して変更内容を確認する

必要に応じて修正を加える。
Phoenixのバージョンアップによりどういう影響がでるのかはわからない。
言えることは、必要に応じてとしか言えない。

特に取り込みが必要なのは、 `aht20_tracker/lib/aht20_tracker_web/router.ex`

```
  scope "/api", Aht20TrackerWeb do
    pipe_through :api
    post "/aht20-conditions", Aht20ConditionsController, :create
  end
```

その他、細かな `key` (ランダム値) の変更は新しく生成された値の採用でもよいはず。もちろん、元にもどしてもよい。
