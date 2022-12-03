# Database Model

The database model was inspired by the defined [Business Entities](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/entities.md).

## Entities x Persistence

This project was inspired by concepts like Domain Driven Design and Clean Architecture.

These concepts handles business entities and the persistence layer as different things. These two things are very related to each other, but are not the same. 

When we think about the business (Entities), we are thinking about how non-tech people understands the business, the naming they give to entities and its attributes, the expected rules related to these components.

When we think about persistence, the naming could even be the same, but there are other concerns to be handled like integration of the data, performance of queries using these data, reuse of the data structures, etc...

For example, for the business is important that a **Planet** is related to one or many **Climates**, but how this will be persisted can impact in a lot of aspects of the application like performance or reuse.

There are also persistence fields that are not mapped as business entity attributes, like the persistence dates (`inserted_at` and `updated_at`) that specifies when the data was persisted and the `deleted_at` field used for [soft delete](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/soft-delete.md) that is a technical requirement and not a business requirement.

## Timestamp fields and timezone

All the timestamp fields are created as `timestamp without timezone` understanding that the data will always be persisted in UTC-0 timezone.

Having different timezones at database can become messy and the application can handle better the timezone differences if it exists. 

## Database tables

### climates

| Field              | Description                                               | Type                       | Rules / Validations                           |
|--------------------|-----------------------------------------------------------|----------------------------|-----------------------------------------------|
| id                 | The identifier of the climate.                            | character varying          | PK                                            |
| name               | The name of the climate.                                  | character varying          | Not null, Limit 60 characters                 |
| integration_source | The related integration source.                           | character varying          | Not null, Valid integration source enum value |
| inserted_at        | Timestamp of when the data was inserted.                  | timestamp without timezone | Not null                                      |
| updated_at         | Timestamp of when the data was updated for the last time. | timestamp without timezone | Not null                                      |
| deleted_at         | Timestamp of when the data was deleted.                   | timestamp without timezone |                                               |

#### Indexes

  * deleted_at

### terrains

| Field              | Description                                               | Type                       | Rules / Validations                           |
|--------------------|-----------------------------------------------------------|----------------------------|-----------------------------------------------|
| id                 | The identifier of the terrain.                            | character varying          | PK                                            |
| name               | The name of the terrain.                                  | character varying          | Not null, Limit 60 characters                 |
| integration_source | The related integration source.                           | character varying          | Not null, Valid integration source enum value |
| inserted_at        | Timestamp of when the data was inserted.                  | timestamp without timezone | Not null                                      |
| updated_at         | Timestamp of when the data was updated for the last time. | timestamp without timezone | Not null                                      |
| deleted_at         | Timestamp of when the data was deleted.                   | timestamp without timezone |                                               |

#### Indexes

  * deleted_at

### movie_directors

| Field              | Description                                               | Type                       | Rules / Validations                           |
|--------------------|-----------------------------------------------------------|----------------------------|-----------------------------------------------|
| id                 | The identifier of the movie director.                     | uuid v4                    | PK                                            |
| name               | The name of the movie director.                           | character varying          | Not null, Limit 255 characters                |
| integration_source | The related integration source.                           | character varying          | Not null, Valid integration source enum value |
| inserted_at        | Timestamp of when the data was inserted.                  | timestamp without timezone | Not null                                      |
| updated_at         | Timestamp of when the data was updated for the last time. | timestamp without timezone | Not null                                      |
| deleted_at         | Timestamp of when the data was deleted.                   | timestamp without timezone |                                               |

#### Indexes

  * deleted_at

### movies

| Field              | Description                                               | Type                       | Rules / Validations                           |
|--------------------|-----------------------------------------------------------|----------------------------|-----------------------------------------------|
| id                 | The identifier of the movie.                              | uuid v4                    | PK                                            |
| title               | The title of the movie.                                    | character varying          | Not null, Limit 255 characters                |
| release_date       | The date that the movie was released.                     | date                       | Not null                                      |
| integration_source | The related integration source.                           | character varying          | Not null, Valid integration source enum value |
| integration_id     | The ID at the integration source.                         | character varying          |                                               |
| inserted_at        | Timestamp of when the data was inserted.                  | timestamp without timezone | Not null                                      |
| updated_at         | Timestamp of when the data was updated for the last time. | timestamp without timezone | Not null                                      |
| deleted_at         | Timestamp of when the data was deleted.                   | timestamp without timezone |                                               |

#### Indexes

  * deleted_at
  * [integration_source, integration_id] unique for not deleted records

### planets

| Field              | Description                                               | Type                       | Rules / Validations                           |
|--------------------|-----------------------------------------------------------|----------------------------|-----------------------------------------------|
| id                 | The identifier of the planet.                             | uuid v4                    | PK                                            |
| name               | The name of the planet.                                   | character varying          | Not null, Limit 60 characters                |
| integration_source | The related integration source.                           | character varying          | Not null, Valid integration source enum value |
| integration_id     | The ID at the integration source.                         | character varying          |                                               |
| inserted_at        | Timestamp of when the data was inserted.                  | timestamp without timezone | Not null                                      |
| updated_at         | Timestamp of when the data was updated for the last time. | timestamp without timezone | Not null                                      |
| deleted_at         | Timestamp of when the data was deleted.                   | timestamp without timezone |                                               |

#### Indexes

  * deleted_at
  * [integration_source, integration_id] unique for not deleted records

### planets_climates

| Field      | Description                         | Type              | Rules / Validations |
|------------|-------------------------------------|-------------------|---------------------|
| id         | The identifier of the relationship. | uuid v4           | PK                  |
| planet_id  | The ID of the planet.               | uuid v4           | FK, Not null        |
| climate_id | The ID of the climate.              | character varying | FK, Not null        |

#### Indexes

  * [planet_id, climate_id] unique

### planets_movies

| Field      | Description                         | Type              | Rules / Validations |
|------------|-------------------------------------|-------------------|---------------------|
| id         | The identifier of the relationship. | uuid v4           | PK                  |
| planet_id  | The ID of the planet.               | uuid v4           | FK, Not null        |
| movie_id   | The ID of the movie.                | uuid v4           | FK, Not null        |

#### Indexes

  * [planet_id, movie_id] unique

### planets_terrains

| Field      | Description                         | Type              | Rules / Validations |
|------------|-------------------------------------|-------------------|---------------------|
| id         | The identifier of the relationship. | uuid v4           | PK                  |
| planet_id  | The ID of the planet.               | uuid v4           | FK, Not null        |
| terrain_id | The ID of the terrain.              | character varying | FK, Not null        |

#### Indexes

  * [planet_id, terrain_id] unique
