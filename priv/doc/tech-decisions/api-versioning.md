# Technical decision about versioning the API

Since this is a challenge, there is no expectations of releasing new versions of the API. Even though I did something simple just to show that I was concerned about possible future updates.

Every route, controller and serializer are namespaced by the version (for now just the v1) and if something needs to be changed that could break the interface, another namespace can easily being created.
