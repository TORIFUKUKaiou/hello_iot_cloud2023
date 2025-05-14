# Hello IoT Cloud

## aht20_tracker

API server application using Phoenix. Comes with .devcontainer/phoenix configuration.

When developing in a devcontainer, it's best to open the `aht20_tracker` folder as the root. This is because if you don't, files like router.ex and migration files may be formatted differently than intended. If you prefer to keep the project root as is, you can also set `"elixirLS.projectDir": "aht20_tracker"` in your configuration.

## hello_nerves

A Nerves application that measures temperature and humidity from the AHT20 module and sends the data to the API server.
