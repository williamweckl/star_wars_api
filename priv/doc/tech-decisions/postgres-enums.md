# Technical decision about using PostgreSQL enums

PostgreSQL has a feature called [Enumerated Types](https://www.postgresql.org/docs/current/datatype-enum.html).

PostgreSQL enums are equivalent to enums at programming languages, but enforces the use of specific defined values at the database too and not just at the application.

Postgres enums also have some performance improvements compared to the use of simple strings and using it also helps the data to be more legible since it is shown as a common string at queries and database tools.

This feature has been used at this project for the `integration source enum` and the biggest motivation was the integrity of the database, that will prevent that values not mapped could be inserted/updated manually. If that happened it would break the application.
