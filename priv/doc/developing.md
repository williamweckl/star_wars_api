# Developing

**IMPORTANT NOTICE:** For the bellow commands work within the application docker container, you need to start the application container first using the [start](https://github.com/williamweckl/star_wars_api/blob/main/README.md#start) section instructions.

You can also run the application's raw commands without docker if you have Elixir installed locally. To do that, follow this [guide](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/using-elixir-with-asdf.md#developing).

## CI

After submitting a Pull Request (PR) or a PR is merged to the main branch, a CI tool ([CircleCI](https://circleci.com/)) will run all the tests, the code linter and it will also check for compilation warnings and code formatting.

The new application code needs to pass the coverage (100% check), the unit tests, the linter, code formatting and must not have any compilation warnings to be able to be merged.

If you are developing new features, you probably don't want to wait for the CI every commit/push you do. You can perform this checks by running the specific tools instructed bellow.

## Compilation warnings

The most common compilation warnings are variables or private functions not being used, other errors usually would prevent the application to run.

You can see this warnings when running the application or running it's tests at the terminal output. Usually it is a yellow message.

Some libraries can have warnings also, but libraries warnings are out of our control and does not raise errors at CI.

## Linter

For code linting, the library [credo](https://github.com/rrrene/credo) was used.

You can run credo inside the docker container by running the command:

```
make docker.code.lint
```

You can also pass arguments to the linter command to check a single file or path. To do that follow the example bellow:

```
ARGS="lib/star_wars.ex" make docker.code.lint
```

## Code format

Elixir has a built in code formatter that helps us keep our code formatted according to community standards.

You can run the formatter with the bellow command:

```
make docker.code.format
```

The command usually does not have an output, it just formats the files. You can run `git status` to see the files changed.

## Running tests

For unit tests, the tool [ExUnit](https://hexdocs.pm/ex_unit/1.12/ExUnit.html) is being used. ExUnit comes with Elixir without the need of aditional setup.

You can run ExUnit inside the docker container by running the command:

```
make docker.app.test
```

You can also pass arguments to the command to test a single file or path. To do that follow the example bellow:

```
ARGS="test/star_wars_api/views/error_view_test.exs" make docker.app.test
```

### Code Coverage

To check the code coverage, we use the library [ExCoveralls](https://github.com/parroty/excoveralls).

You can run ExUnit with ExCoveralls inside the docker container by running the command:

```
make docker.app.test_with_coverage
```

You can also pass arguments to the command to test a single file or path. To do that follow the example bellow:

```
ARGS="test/star_wars_api/views/error_view_test.exs" make docker.app.test_with_coverage
```

The above commands generates an HTML file with the coverage summary at `cover/excoveralls.html`. You can run it by your browser to see the output.

Also the HTML coverage report is being uploaded as an artifact when the CI runs. This helps to identify files or lines of code that are not covered.
