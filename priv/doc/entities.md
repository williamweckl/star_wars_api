# Entities

## Climate

This entity represents a climate.

| Attribute          | Description                                                                                                       | Type   | Rules / Validations                  |
|--------------------|-------------------------------------------------------------------------------------------------------------------|--------|--------------------------------------|
| ID                 | The identifier of the climate.                                                                                    | string | Reference key (PK), Required, Unique |
| Name               | The name of the climate.                                                                                          | string | Required, Min 3 characters, Max 60 characters          |
| Integration Source | The related integration source. When the integration process runs, it will register the integration source used. | string | Required                             |                           |

## Terrain

This entity represents a terrain.

| Attribute          | Description                                                                                                       | Type   | Rules / Validations                  |
|--------------------|-------------------------------------------------------------------------------------------------------------------|--------|--------------------------------------|
| ID                 | The identifier of the terrain.                                                                                    | string | Reference key (PK), Required, Unique |
| Name               | The name of the terrain.                                                                                          | string | Required, Min 3 characters, Max 60 characters          |
| Integration Source | The related integration source. When the integration process runs, it will register the integration source used. | string | Required                             |                           |

## Movie Director

This entity represents a Star Wars movie director.

| Attribute          | Description                                                                                                       | Type                    | Rules / Validations                  |
|--------------------|-------------------------------------------------------------------------------------------------------------------|-------------------------|--------------------------------------|
| ID                 | The identifier of the movie director.                                                                             | automatically generated | Reference key (PK), Required, Unique |
| Name               | The name of the movie director.                                                                                   | string                  | Required, Max 255 characters         |
| Integration Source | The integration source related.  When the integration process runs, it will register the integration source used. | string                  | Required                             |

## Movie

This entity represents a Star Wars movie.

| Attribute          | Description                                                                                                       | Type                    | Rules / Validations                  |
|--------------------|-------------------------------------------------------------------------------------------------------------------|-------------------------|--------------------------------------|
| ID                 | The identifier of the movie.                                                                                      | automatically generated | Reference key (PK), Required, Unique |
| Title               | The title of the movie.                                                                                            | string                  | Required, Max 255 characters         |
| Release date       | The date that the movie was released.                                                                             | date                    | Required                             |
| Integration Source | The integration source related.  When the integration process runs, it will register the integration source used. | string                  | Required                             |
| Integration ID     | The ID at the integration source. For example: the ID at the public star wars API.                                | string                  |                                      |

## Planet

This entity represents a planet.

| Attribute          | Description                                                                                                       | Type                    | Rules / Validations                                      |
|--------------------|-------------------------------------------------------------------------------------------------------------------|-------------------------|----------------------------------------------------------|
| ID                 | The identifier of the planet.                                                                                     | automatically generated | Reference key (PK), Required, Unique                     |
| Name               | The name of the planet.                                                                                           | string                  | Required, Max 60 characters                              |
| Climates           | The related climates.                                                                                             | list of climates        | Valid registered climates, Required to have at least one |
| Terrains           | The related terrains.                                                                                             | list of terrains        | Valid registered terrains, Required to have at least one |
| Movies             | The related movies.                                                                                               | list of movies          | Valid registered movies, Required to have at least one   |
| Integration Source | The integration source related.  When the integration process runs, it will register the integration source used. | string                  | Required                                                 |
| Integration ID     | The ID at the integration source. For example: the ID at the public star wars API.                                | string                  |                                                          |
