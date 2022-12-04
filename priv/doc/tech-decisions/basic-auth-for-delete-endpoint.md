# Technical decision about using Basic Auth for delete endpoint

To keep delete endpoint more secure, I implemented a simple authentication method (HTTP Basic Auth).

Since this is just a challenge, I understood that was not necessary to implement auth for get endpoints.

## Why using HTTP Basic auth?

In a real world application probably we would want to use something more robust, but for the challenge proposal it was chosen something simplier and easier to implement/test.

I also wanted that the reviewers could test the solution without any complications and HTTP Basic auth does not requires any setup like user insert or something like that.

## The password

For development and testing environments, the password was setted as `admin` at the config files [config/dev.exs](https://github.com/williamweckl/star_wars_api/blob/main/config/dev.exs#L28) and [config/test.exs](https://github.com/williamweckl/star_wars_api/blob/main/config/test.exs#L25)

Notice that it was not setted at `config/config.exs` to avoid having a default password setted to all environments. This prevents that new environments comes with an insecure password configuration that should be only for development/testing.

For production environments, this configuration must come from an environment variable. The reading of the environment variable was setted at [config/runtime.exs](https://github.com/williamweckl/star_wars_api/blob/main/config/runtime.exs#L51).

## How to use

Set the header Authorization to the base 64 encoded string `admin:<password_setted_at_config>` (eh.: `admin:admin`) with the prefix `Basic `.

Example using curl and admin password:

```bash
curl --header "Authorization: Basic YWRtaW46YWRtaW4="
```
