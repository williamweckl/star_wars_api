# Using Elixir with ASDF

ASDF is a tool version manager that helps the instalation of programming languages and other tools according to the definitions contained within the file `.tool-versions`.

You can install ASDF by following the [guide](https://asdf-vm.com/guide/getting-started.html).

After installing ASDF, you need to add the plugins needed by this project. You can do this by running the bellow commands:

  * `asdf plugin add elixir`
  * `asdf plugin add erlang`

When the plugins are ready, you can install the versions needed by the project by running:

  * `asdf install`

## Installing project dependencies

After installing Elixir, you can install the project dependencies by running the command:

  * `mix deps.get`

## Using locally installed Elixir with the related services from containers

The database and other services related to the project can be run by using the command:

  * `make docker.services.start`

The command above will start only the related services and the application can be run this using the local Elixir installation.

## Postgres Database

If you wish, you can use a local installation of postgres, to do that you need to change the database credentials at the file `config/dev.exs`.

The database structure setup will happen at the first start of the server.

## Start the server

To start the application server:

  * Start Phoenix API with `mix phx.server` or inside Interactive Elixir console (iex) with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Developing

### Linter

For code linting, the library [credo](https://github.com/rrrene/credo) was used.

You can run the linter by running the command:

```
mix credo 
```

You can also pass arguments to the linter command to check a single file or path. To do that follow the example bellow:

```
mix credo lib/star_wars_api.ex
```

### Running tests

**IMPORTANT NOTICE:** For the test commands work, you need to start the application container first using the [start](#start) section instructions.

For unit tests, the tool [ExUnit](https://hexdocs.pm/ex_unit/1.12/ExUnit.html) is being used. ExUnit comes with Elixir without the need of aditional setup.

You can run ExUnit inside the docker container by running the command:

```
mix test
```

You can also pass arguments to the command to test a single file or path. To do that follow the example bellow:

```
mix test test/star_wars_api_web/views/error_view_test.exs
```

Tests are also run at CI automatically every pull request and for the main branch.

#### Code Coverage

To check the code coverage, we use the library [ExCoveralls](https://github.com/parroty/excoveralls).

You can run ExUnit with ExCoveralls inside the docker container by running the command:

```
mix coveralls.html
```

You can also pass arguments to the command to test a single file or path. To do that follow the example bellow:

```
mix coveralls.html test/star_wars_api_web/views/error_view_test.exs
```

The above commands generates an HTML file with the coverage summary at `cover/excoveralls.html`. You can run it by your browser to see the output.

Coverage checks are also run at CI automatically every pull request and for the main branch.
