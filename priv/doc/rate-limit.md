# API Rate Limit

Besides not the requirement of the challenge, I wanted to implement something simple just to show the concept being applied.

Rate Limit was implemented using the Elixir library [ExHammer](https://github.com/ExHammer/hammer) that has some backends to persist the request counts. The backend chosen was the simplier one (ETS), as I mentioned before the idea was to just show the concept.

Using ETS backend, ExHammer will persist the information it needs to ETS tables, that are in memory structures from Erlang.

The approach is not very good for production - [as the library documentation suggests](https://github.com/ExHammer/hammer/blob/master/README.md?plain=1#L76) - because usually production environments has load balancers with more than one application running. Persisting the data only to the instance's memory will make that the user can do more requests as allowed by the configuration.

Other thing that can happen with this approach is that the data will be reseted when the system restarts for some reason like a deploy.

Since this implementation is just a show case, it is ok to use this strategy. To use others would be necessary to use additional services like Redis or Mnesia, making the project more complex that it needs.

## How to test

Just call one of the implemented endpoints a lot of times in the same minute. After 10 requests, the response will have the status 429 with an error message inside a JSON structure.

You can wait one minute and try again and you will see that is all ok.
