# Star Wars API

Project built for a challenge to join a misterious galactic company.

Would be this company from the empire? Would be from the republic? We don't know yet, but they want to use an API to build something great on the top of it, I think it's a game. Would this great game help the galaxy or would this game be used to aid an evil plan?

The company is awesome, so I'm pretty sure they have good intentions for the galaxy. :D

## The idea

A Rest API that contains data of the planets inserted by requests triggered to the public Star Wars API. For each of this planets, some data of the Star Wars movies needs to be related.

One of the requirements is that the application has a database and persists the planets data. Besides this is a requirement of the challenge, I would probably make this decision too to avoid be blocked by some rate limit of the Star Wars API. We don't want our nice game depending on something we don't have control, is that right?! This also allows us to implement future needs and some aditional data that is not present by the original public Star Wars API.

The idea is to consume the API and persist the information to this database, after that, the API should respond using just the database, without being coupled to the public Star Wars API.

Other decisions made are specified at this README.

## Features required by the challenge

  * Load a planet from the public Star Wars API by it's ID.
  * List the planets.
  * Search a planet by it's name.
  * Get a planet by it's ID.
  * Remove a planet.

## Start

To start the application server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside Interactive Elixir console (iex) with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
