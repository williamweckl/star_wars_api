# Libraries used for testing

## [ExCoveralls](https://github.com/parroty/excoveralls)

Used to check the code coverage. It generates an HTML file with the coverage summary at `cover/excoveralls.html`. You can run it by your browser to see the output.

Also the HTML coverage report is being uploaded as an artifact when the CI runs. This helps to identify files or lines of code that are not covered.

## [junit_formatter](https://github.com/victorolinasc/junit-formatter)

Used to generate tests reports in the junit format that is compatible with Circle CI. This report is uploaded as artifact when the CI runs.

## [ExMachina](https://github.com/thoughtbot/ex_machina)

Used to produce factories used to test records whenever they are persisted or not to the database.

## [Mock](https://github.com/jjh42/mock)

Mock library being used to write unit tests without having to execute some aditional code every time.

It is also used for testing modules like [HTTPClient](https://github.com/williamweckl/star_wars_api/blob/main/lib/star_wars/http_client.ex) and [Star Wars public API adapter](https://github.com/williamweckl/star_wars_api/blob/main/lib/star_wars/integration_source/adapters/star_wars_public_api.ex) to avoid real HTTP requests to being triggered.

Despite being necessary, mocks should be used with caution because in addition to being slower than the execution of the code itself, there are other alternatives that are more appropriate for most scenarios. There is an [excelent article](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/) wrote by José Valim that is the creator of Elixir that explains some of these alternatives.

Mocking [HTTPClient](https://github.com/williamweckl/star_wars_api/blob/main/lib/star_wars/http_client.ex) and [Star Wars public API adapter](https://github.com/williamweckl/star_wars_api/blob/main/lib/star_wars/integration_source/adapters/star_wars_public_api.ex) was inevitable, but the rest of the code uses `testing clients` that are more efficient because we don't have to write mocks everywhere making our tests less coupled to those clients.

You can see this strategy implemented at the files [lib/star_wars/integration_source/adapters/mock.ex](https://github.com/williamweckl/star_wars_api/blob/main/lib/star_wars/integration_source/adapters/mock.ex) and [config/test.exs](https://github.com/williamweckl/star_wars_api/blob/main/config/test.exs#L4).
