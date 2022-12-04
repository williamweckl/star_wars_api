# Make

`make` is an utility for building and maintaining groups of programs. In the case of this project it was used to facilitate the use of docker commands by having less complicated and more readable commands to execute some common tasks like start the application or load a planet.

Usually `make` comes already installed by Linux distributions and macOs.

## Make commands

  * `make help`:                    Show all make commands.
  * `make docker.app.start`:        Start APP containers.
  * `make docker.app.load_planet_from_integration`:         Loads a planet from the integration. Use the env ARGS to set the planet ID.
  * `make docker.app.stop`:         Stop APP containers.
  * `make docker.app.logs`:         Show logs from APP containers. Use the env ARGS to set more options of docker-compose logs.
  * `make docker.app.test`:         Run ExUnit test tool inside docker container. Use the env ARGS to set the file and the line you want to test.
  * `make docker.app.test_with_coverage`:   Run ExUnit test tool with coverage check inside docker container. Use the env ARGS to set the file and the line you want to test.
  * `make docker.code.lint`:         Run linter inside docker container. Use the env ARGS to set the file and the line you want to run the linter.
  * `make docker.code.format`:   Run elixir formatter inside docker container.
  * `make docker.services.start`:   Start services containers.
  * `make docker.services.stop`:    Stop services containers
  * `make docker.services.logs`:    Show logs from services containers. Use the env ARGS to set more options of docker-compose logs.

The above commands are executed at the terminal.
