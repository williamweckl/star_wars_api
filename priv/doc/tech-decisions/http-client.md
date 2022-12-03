# Technical decision about using a HTTP Client Wrapper

I chose to develop a wrapper as an intermediate layer between the application use cases and the HTTP Client library (HTTPoison).

The [HTTPoison](https://github.com/edgurgel/httpoison) library is a great library, with recent updates, a lot of downloads and contributions. But even with the library being maintained by the community, major versions could still break the implementation made for this project.

A wrapper can help us make this changes in one place, avoiding having to rewrite a lot of code.

Usually is a good practice to be less coupled to external libraries. Updates are easier and the side effects are self contained. If something needs to be changed for all HTTP Requests there is just one place to do it, the HTTPClient module.

You can see the HTTPClient module code [here](https://github.com/williamweckl/star_wars_api/blob/main/lib/star_wars/http_client.ex).
