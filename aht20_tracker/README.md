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

## Docker Image Push

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
