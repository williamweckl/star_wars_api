# Technical decision about using Serializers

In general, is a bad practice to expose business entities and database records as-is to endpoints without having a layer in the front of it.

It is considered a bad practice because some database fields or entity attributes could give the user more information than he needs and it can cause some confusion. Also malicious users can take advantage of this if they try to find a security breach.

For example, at our structure we use [soft deletes](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/tech-decisions/soft-delete.md) by defining a field called `deleted_at`. The user or client that is consuming the API does not need to know that we do that, for all intents and purposes that record was deleted. Exposing the `deleted_at` field to the API can lead to misunderstandings in the best scenario.

## The use of Serializers

Serializer is a layer between the entity/record and the endpoint. Every entity passes though the serializer that explicit tells what can be exposed to the API.

In other words, the serializer receives an entity and converts it to a data structure that can be exposed to the API.

Another benefit of using serializers is that some data conversions can be applied at this layer, exposing a data that makes more sense to the user/client.
