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
