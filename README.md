# Star Wars API

Project built for a challenge to join a misterious galactic company.

Would be this company from the empire? Would be from the republic? I don't know yet, but they want to use an API to build something great on the top of it, I think it's a game. Would this great game help the galaxy or would this game be used to aid an evil plan?

The company is awesome, so I'm pretty sure they have good intentions for the galaxy. :D

## The idea

A Rest API that contains data of the planets inserted by requests triggered to the public Star Wars API. For each of this planets, some data of the Star Wars movies needs to be related.

One of the requirements is that the application has a database and persists the planets data. Besides this is a requirement of the challenge, I would probably make this decision too to avoid be blocked by some rate limit of the public Star Wars API. We don't want our nice game depending on something we don't have control, is that right?! This also allows us to implement future needs and some aditional data that is not present by the original public Star Wars API.

The idea is to consume the API and persist the information to the APP's database, after that, the API should respond using just the database, without being coupled to the public Star Wars API.

Other decisions made are specified at this README.

## Features required by the challenge

  * Load a planet from the public Star Wars API by it's ID.
  * List the planets.
  * Search a planet by it's name.
  * Get a planet by it's ID.
  * Remove a planet.

## Technologies used

### Erlang

Erlang is a programming language known for creating low-latency, distributed and fault-tolerant systems.

All the code writen by this project is compiled to be excecuted by the Erlang VM (Beam).

### Elixir

Elixir is a functional language built on the top of the Erlang VM. Every code writen in Elixir is compiled and runs on the Erlang VM.

Erlang is a very verbose language created at 1986 and Elixir manages to take advantage of what Erlang has good but with a more friendly and productive syntax.

You don't have to understand Erlang code to understand the code writen at this project, you just need to understand Elixir code.

#### Why use Elixir for this challenge?

The company behind this challenge (TOP SECRET COMPANY - HAHAHA) does not use Elixir, but they didn't specify the language needed to write the code either.

Elixir was chosen for this project just because I am more familiar with and I believe that a functional language helps us to keep things more self contained, with less side effects at the code than an Object Oriented approach. The web framework (Phoenix) also helps a lot with RESTful API's building that is the purpose of this project.

#### Tradeoffs

Besides of the benefits of the Elixir language, there is no silver bullet. Elixir is a very performant and productive language, but is not one of the most popular languages and this can make hiring new people a little difficult.

Since this project is just a challenge, the negative hiring impacts does not apply.

#### Don't know Elixir?

Not familiar with Elixir yet and need to read this code? No problem, Elixir code should be easy to understand but if you need there are some materials that can help you get more familiar:

  * [Elixir guides](https://elixir-lang.org/getting-started/introduction.html)
  * [Elixir documentation](https://hexdocs.pm/elixir/Kernel.html)

### Phoenix framework

Phoenix is a web framework for the Elixir language and was chosen because it has a lot of tools that helps us building a REST API that is the purpose of this challenge. Phoenix is also the most popular web framework for Elixir.

#### Don't know Phoenix?

Don't worry. It has a structure that should be easy to understand, but I've compiled some links that could help you understand even more.

This bellow links can help:

  * [Official website](https://www.phoenixframework.org/)
  * [Guides](https://hexdocs.pm/phoenix/overview.html)
  * [Docs](https://hexdocs.pm/phoenix)
  * [Forum](https://elixirforum.com/c/phoenix-forum)
  * [Source](https://github.com/phoenixframework/phoenix)

### PostgreSQL

The database chosen to be used at this challenge is PostgreSQL. The reasons behind that decision are:

  * It is free
  * It's features are more than enough to build this challenge
  * Nice compatibility with Phoenix framework
  * Is the most common choice for Phoenix applications

## Setup

The project is dockerized, this means that all commands and the web server can be run by using docker containers. This should be the easier way to run the application and the setup is being made automatically at the first run by using docker commands, without any installation of the database, language and libraries.

You just need to have [docker](https://docs.docker.com/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/) installed. With these two tools ready, you can run the application by folling the section to [start the APP](#start).

If you wish, you can still install Elixir language and run this project. I usually prefer this approach when I'm an active developer of the project because integrating IDE's or other tools to write code with linters and other language tools can be painfull. If you want, [here is a guide to install Elixir using ASDF](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/using-elixir-with-asdf.md).

You can also install the language by common ways (without ASDF or other version tool), but I don't recommend it because it would be very difficult to handle the case that are multiple projects using different versions of Elixir/Erlang and also version upgrades could be easier by using a tool like ASDF.

### Database structure

The database structure setup will happen at the first start of the server.

## Start

To start the application server:

  * Start the server and related services with the command: `make docker.app.start`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
