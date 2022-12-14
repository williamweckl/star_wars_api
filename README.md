# Star Wars API

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/williamweckl/star_wars_api/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/williamweckl/star_wars_api/tree/main)

Project built for a challenge to join a misterious galactic company.

Would be this company from the empire? Would be from the republic? I don't know yet, but they want to use an API to build something great on the top of it, I think it's a game. Would this great game help the galaxy or would this game be used to aid an evil plan?

The company is awesome, so I'm pretty sure they have good intentions for the galaxy. :D

## The idea

A Rest API that contains data of the planets inserted by requests triggered to the public Star Wars API. For each of this planets, some data of the Star Wars movies needs to be related.

One of the requirements is that the application has a database and persists the planets data. Besides this is a requirement of the challenge, I would probably make this decision too to avoid be blocked by some rate limit of the public Star Wars API. We don't want our nice game depending on something we don't have control, is that right?! This also allows us to implement future needs and some aditional data that is not present by the original public Star Wars API.

The idea is to consume the API and persist the information to the APP's database, after that, the API should respond using just the database, without being coupled to the public Star Wars API.

Other decisions made are specified at this README.

## Features required by the challenge

  * Load a planet from the public Star Wars API by it's ID
  * List the planets
  * Search a planet by it's name
  * Get a planet by it's ID
  * Remove a planet

## Aditional features implemented

  * [Basic HTTP Authentication for delete endpoint](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/basic-auth-for-delete-endpoint.md)
  * [Soft Delete](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/soft-delete.md)
  * [API Rate Limit](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/rate-limit.md)
  * [Monitoring](#monitoring)
  * Movies list endpoint
  * Get a movie by it's ID endpoint

## Documentation and guides

  * [Technologies used](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/techs-used.md)
  * [Setup](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/setup.md)
  * [Developing, testing, linting](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/developing.md)
  * [Make commands](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/make-commands.md)
  * [Project Architecture](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/project-architecture.md)
  * [Business Entities](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/entities.md)
  * [Database Model](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/database-model.md)
  * [Endpoints documentation](https://app.swaggerhub.com/apis/WILLIAMWECKL_1/star_wars_api/1.0.0)
  * [API Rate Limit](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/rate-limit.md)

## Technical decisions

  * [Test libraries used](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/test-libraries.md)
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
  * [Basic HTTP Authentication](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/basic-auth-for-delete-endpoint.md)
  * [Planet delete use case receiving deleted_at as input parameter](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/delete-use-case-receiving-date.md)

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

### get /v1/planets

List planets.

[Endpoint documentation](https://app.swaggerhub.com/apis/WILLIAMWECKL_1/star_wars_api/1.0.0#/planet/get_v1_planets)

You can test the endpoint by running the below curl command:

```bash
curl --header "Content-Type: application/json" http://localhost:4000/v1/planets
```

You can filter by name by running the below curl command:

```bash
curl --header "Content-Type: application/json" http://localhost:4000/v1/planets?name=tatoo
```

### get /v1/planets/:planet_id

Get an existing planet by its ID.

[Endpoint documentation](https://app.swaggerhub.com/apis/WILLIAMWECKL_1/star_wars_api/1.0.0#/planet/get_v1_planets__planet_id_)

You can test the endpoint by running the below curl command:

```bash
curl --header "Content-Type: application/json" http://localhost:4000/v1/planets/<planet_id>
```

Don't forget to change the `<planet_id>` above to an existent planet id.

### delete /v1/planets/:planet_id

Deletes an existing planet by its ID.

[Endpoint documentation](https://app.swaggerhub.com/apis/WILLIAMWECKL_1/star_wars_api/1.0.0#/planet/delete_v1_planets__planet_id_)

You can test the endpoint by running the below curl command:

```bash
curl --header "Content-Type: application/json" --header "Authorization: Basic YWRtaW46YWRtaW4=" --request "DELETE" http://localhost:4000/v1/planets/<planet_id>
```

Don't forget to change the `<planet_id>` above to an existent planet id.

### get /v1/movies

List movies.

[Endpoint documentation](https://app.swaggerhub.com/apis/WILLIAMWECKL_1/star_wars_api/1.0.0#/movie/get_v1_movies)

You can test the endpoint by running the below curl command:

```bash
curl --header "Content-Type: application/json" http://localhost:4000/v1/movies
```

You can filter by title by running the below curl command:

```bash
curl --header "Content-Type: application/json" http://localhost:4000/v1/movies?title=return
```

### get /v1/movies/:movie_id

Get an existing movie by its ID.

[Endpoint documentation](https://app.swaggerhub.com/apis/WILLIAMWECKL_1/star_wars_api/1.0.0#/movie/get_v1_movies__movie_id_)

You can test the endpoint by running the below curl command:

```bash
curl --header "Content-Type: application/json" http://localhost:4000/v1/movies/<movie_id>
```

Don't forget to change the `<movie_id>` above to an existent movie id.

## Application Logs

All the logs the application produces are printed to the terminal and also persisted to files stored at the `logs/` folder at the project root.

Info logs are stored in a file called `info.log` and errors inside a file called `errors.log`. For development and test environments, to differ the environment, the files are stored in a subfolder from logs named according to the enviroment.

For development environment, the log format was opted to be something more readable by the developers according to the example:

```
12:22:20.726 module=Mix.Tasks.LoadPlanetFromIntegration [info] Planet was loaded successfully!
```

Production log format configuration is very similar with the change that the timestamp contains also the date. The decision was to keep the production configuration as the default for phoenix applications since there is no tool to extract this logs yet. Most of the tools can handle this default format and some improvements can be made in the future.

## Monitoring

To monitor the application requests and processes the [Phoenix LiveDashboard](https://github.com/phoenixframework/phoenix_live_dashboard) tool was used. Since this is just a challenge, I think this is enought for now just to show the concept.

Phoenix LiveDashboard shows metrics about the request timings, query timings, requests logs, machine resources and other cool things.

Phoenix LiveDashboard can be used even in production.

To access the dashboard you can visit [`localhost:4000/performance_dashboard`](http://localhost:4000/performance_dashboard) from your browser. It will ask for a username and password that is the same for the planet delete endpoint (`admin/admin` for development environment).

## Contributing

We encourage you to contribute to Star Wars API! Just submit a PR that we will be happy to review.

Wanna contribute and don't know where to start? There are some cool features in my mind:

- Climates, Terrains and Movie Directors endpoints
- Able to create and update records without loading it from the Star Wars public API
- Task to load all planets from Star Wars public API
- Search planets by movie, climate, terrain and movie director
- Change the API language by setting Accept-Language header and error messages translation.

If you liked those ideas or have any other feel free to open a feature request issue or a PR. :stuck_out_tongue:
