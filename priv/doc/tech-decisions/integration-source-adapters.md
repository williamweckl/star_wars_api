# Technical decision about using Adapters and the Integration Source structure

The requirements of the challenge was pretty clear: integrate with Star Wars public API to load planet data.

But what happens if this API does not exist anymore? Or if they release a new version that changes a lot the contract?

When I received the challenge, the API URL at the document received was wrong and then I realized that they changed it. This and other scenarios can still happen.

To minimize some of these side effects, I proposed a structure composed by adapters to these APIs. I've called the APIs as `Integration Sources` and each adapter corresponds to one API. If the API changes I just have to update the adapter related to it. If the API releases a new version, I can create another adapter to the new version without impacting the version that is already working.

For now I implemented 2 adapters:

  * Star Wars public API: The name describes it well, is the adapter that make requests to the Star Wars public API.
  * Mock: The adapter that is being used for testing environment, to avoid real HTTP requests to being triggered.

The Use Case to load a planet from the integration receives the ID of the integration source and does the rest.

It also worth to mention that the adapters are compatible to each other, this means that the same public functions implemented at one adapter is also implemented by the other. They should have a common interface and switching between adapters should be easy, you can do that by changing the config at the file [config/config.exs](https://github.com/williamweckl/star_wars_api/blob/main/config/config.exs#L14) - or if you prefer you can overwrite this config at the environment you are running the system, like is being made for testing at [config/test.exs](https://github.com/williamweckl/star_wars_api/blob/main/config/test.exs#L4).

This config is being used at the [task file](https://github.com/williamweckl/star_wars_api/blob/main/lib/mix/tasks/load_planet_from_integration.ex#L17).
