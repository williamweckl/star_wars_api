# Project architecture

Architectural decisions were based on concepts such as Domain Driven Design and Clean Architecture.

The idea is that this application represents a business context/domain and every application aspects needs to be a piece of a business use case. 

## Folder Structure

The folder structure was based on Clean Architecture methodology standards and Phoenix framework standards.

![Clean Architecture drawing](https://github.com/williamweckl/star_wars_api/raw/main/priv/doc/clean_architecture.png)

  * priv - Contains all project private files like database migrations and documentation files.
  * lib/star_wars - Contains business logic.
  * lib/star_wars_api - Contains the delivery mechanism logic (In our case, Web API). After the business logic use cases are implemented, the delivery mechanism is responsible to expose the business logic to the user, in this case by REST endpoints.
  * lib/star_wars.ex - Bounded context. Module is responsible for exposing all use cases of the application to the delivery mechanisms. Delivery mechanisms must not call other modules and the repository directly, they must always go through this interface. By reading this file, we have the visibility of all the use cases existing in the application.
  * lib/star_wars/contracts - Validation and construction of input for use cases.
  * lib/star_wars/entities - Business entities defined using [Ecto schemas](https://hexdocs.pm/ecto/Ecto.Schema.html).
  * lib/star_wars/interactors - Use cases / Interactors.
  * lib/star_wars/enums - Application enums using [EctoEnum](https://github.com/gjaldon/ecto_enum).
  * lib/star_wars_api/router.ex - All application routes that will receive requests.
  * lib/star_wars_api/controllers - Responsible for handling requests, calling the bounded context according to the use case and defining the request response.
  * lib/star_wars_api/plugs - Plugs are parts of the Phoenix framework requests pipeline. You can write new plugs and put them in routes to add global behavior or you can add them to a specific controller.
  * lib/star_wars_api/serializers - Serialization of entities to be exposed by the API. Here treatments and filters must be implemented according to what makes sense to expose an entity.
