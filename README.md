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

## Documentation and guides

  * [Technologies used](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/techs-used.md)
  * [Setup](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/setup.md)
  * [Developing, testing, linting](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/developing.md)
  * [Project Architecture](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/project-architecture.md)
  * [Business Entities](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/entities.md)
  * [Database Model](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/database-model.md)
  * [Endpoints documentation](https://app.swaggerhub.com/apis/WILLIAMWECKL_1/star_wars_api/1.0.0)

## Technical decisions

  * [Separated entities for climates and terrains](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/separate-entities-for-climates-and-terrains.md)
  * [Entities IDs](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/ids.md)
  * [PostgreSQL enums](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/postgres-enums.md)
  * [Soft Delete](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/soft-delete.md)
  * [HTTP Client](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/http-client.md)
  * [Contracts](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/contracts.md)
  * [ErrorsHandler](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/errors-handler.md)
  * [Integration Source Adapters](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/integration-source-adapters.md)
  * [Serializers](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/serializers.md)
  * [API Versioning](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/api-versioning.md)

## Start

To start the application server:

  * Start the server and related services with the command: `make docker.app.start`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Loading planets

You can load a planet by running the command:

```bash
# with docker
ARGS="1" make docker.app.load_planet_from_integration

# with Elixir local installation
mix load_planet_from_integration 1
```

The argument being received by the commands is the planet ID, you can change it as you wish.

To run the docker command, the application container needs to be running.

## Using Endpoints

Before calling endpoints, be sure that the server is running. See the [Start](#start) section.

### /v1/planets

[Endpoint documentation](https://app.swaggerhub.com/apis/WILLIAMWECKL_1/star_wars_api/1.0.0#/planet/get_v1_planets)

You can test the endpoint by running the below curl command:

```bash
curl --header "Content-Type: application/json" http://localhost:4000/v1/planets
```

You can filter by name by running the below curl command:

```bash
curl --header "Content-Type: application/json" http://localhost:4000/v1/planets?name=tatoo
```

### /v1/planets/:planet_id

[Endpoint documentation](https://app.swaggerhub.com/apis/WILLIAMWECKL_1/star_wars_api/1.0.0#/planet/get_v1_planets__planet_id_)

You can test the endpoint by running the below curl command:

```bash
curl --header "Content-Type: application/json" http://localhost:4000/v1/planets/<planet_id>
```

Don't forget to change the `<planet_id>` above to an existent planet id.
