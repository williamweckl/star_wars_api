# Entities

## Climate

This entity represents a climate.

| Attribute          | Description                                                                                                       | Type   | Rules / Validations                  |
|--------------------|-------------------------------------------------------------------------------------------------------------------|--------|--------------------------------------|
| ID                 | The identifier of the climate.                                                                                    | string | Reference key (PK), Required, Unique |
| Name               | The name of the climate.                                                                                          | string | Required, Max 60 characters          |
| Integration Source | The related integration source. When the integration process runs, it will register the integration source used. | string | Required                             |                           |

## Terrain

This entity represents a terrain.

| Attribute          | Description                                                                                                       | Type   | Rules / Validations                  |
|--------------------|-------------------------------------------------------------------------------------------------------------------|--------|--------------------------------------|
| ID                 | The identifier of the terrain.                                                                                    | string | Reference key (PK), Required, Unique |
| Name               | The name of the terrain.                                                                                          | string | Required, Max 60 characters          |
| Integration Source | The related integration source. When the integration process runs, it will register the integration source used. | string | Required                             |                           |

## Planet

This entity represents a planet.

| Attribute          | Description                                                                                                       | Type                    | Rules / Validations                                      |
|--------------------|-------------------------------------------------------------------------------------------------------------------|-------------------------|----------------------------------------------------------|
| ID                 | The identifier of the planet.                                                                                     | automatically generated | Reference key (PK), Required, Unique                     |
| Name               | The name of the planet.                                                                                           | string                  | Required, Max 60 characters                              |
| Climates           | The related climates.                                                                                             | list of climates        | Valid registered climates, Required to have at least one |
| Terrains           | The related terrains.                                                                                             | list of terrains        | Valid registered terrains, Required to have at least one |
| Integration Source | The integration source related.  When the integration process runs, it will register the integration source used. | string                  | Required                                                 |
