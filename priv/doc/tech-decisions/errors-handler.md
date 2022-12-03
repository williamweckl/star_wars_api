# Technical decision about the Errors Handler implementation

Usually I would always implement a wrapper around Sentry, Rollbar or any other exception handler tool at my projects, but since this is just a challenge, I've implemented a module that would be this wrapper but for now it is just logging the errors.

You can see the implementation [here](https://github.com/williamweckl/star_wars_api/blob/main/lib/star_wars/errors_handler.ex).
