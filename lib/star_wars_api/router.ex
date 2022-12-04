defmodule StarWarsAPI.Router do
  use StarWarsAPI, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StarWarsAPI do
    pipe_through :api

    get "/", HealthCheckController, :index
    get "/v1", HealthCheckController, :index
  end

  scope "/v1", StarWarsAPI.V1 do
    pipe_through :api

    resources "/planets", PlanetController, only: [:index, :show], as: :v1_planet
  end

  # coveralls-ignore-start

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: StarWarsAPI.Telemetry
    end
  end

  # coveralls-ignore-end
end
