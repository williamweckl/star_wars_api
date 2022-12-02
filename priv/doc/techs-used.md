# Technologies used

## [Erlang](https://www.erlang.org/)

Erlang is a programming language known for creating low-latency, distributed and fault-tolerant systems.

All the code writen by this project is compiled to be excecuted by the Erlang VM (Beam).

## [Elixir](https://elixir-lang.org/)

Elixir is a functional language built on the top of the Erlang VM. Every code writen in Elixir is compiled and runs on the Erlang VM.

Erlang is a very verbose language created at 1986 and Elixir manages to take advantage of what Erlang has to offer but with a more friendly and productive syntax.

You don't have to understand Erlang code to understand the code writen at this project, you just need to understand Elixir code that should not be so difficult.

### Why use Elixir for this challenge?

The company behind this challenge (TOP SECRET COMPANY - HAHAHA) does not use Elixir, but they didn't specify the language needed to write the code either.

Elixir was chosen for this project just because I am more familiar with and I believe that a functional language helps us to keep things more self contained, with less side effects at the code than an Object Oriented approach. The web framework (Phoenix) also helps a lot with RESTful API's building that is the purpose of this project.

### Tradeoffs

Besides of the benefits of the Elixir language, there is no silver bullet. Elixir is a very performant and productive language, but is not one of the most popular languages and this can make hiring new people a little difficult.

Since this project is just a challenge, the negative hiring impacts does not apply.

### Don't know Elixir?

Not familiar with Elixir yet and need to read this code? No problem, Elixir code should be easy to understand but if you need there are some materials that can help you get more familiar:

  * [Elixir guides](https://elixir-lang.org/getting-started/introduction.html)
  * [Elixir documentation](https://hexdocs.pm/elixir/Kernel.html)

## [Phoenix framework](https://www.phoenixframework.org/)

Phoenix is a web framework for the Elixir language and was chosen because it has a lot of tools that helps us building a REST API that is the purpose of this challenge. Phoenix is also the most popular web framework for Elixir.

### Don't know Phoenix?

Don't worry. It has a structure that should be easy to understand, but I've compiled some links that could help you understand even more.

The bellow links can help:

  * [Official website](https://www.phoenixframework.org/)
  * [Guides](https://hexdocs.pm/phoenix/overview.html)
  * [Docs](https://hexdocs.pm/phoenix)
  * [Forum](https://elixirforum.com/c/phoenix-forum)
  * [Source](https://github.com/phoenixframework/phoenix)

## [PostgreSQL](https://www.postgresql.org/)

The database chosen to be used at this challenge is PostgreSQL. The reasons behind that decision are:

  * It is free
  * It's features are more than enough to build this challenge
  * Nice compatibility with Phoenix framework
  * Is the most common choice for Phoenix applications
