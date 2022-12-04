defmodule StarWarsAPI.Router do
  use StarWarsAPI, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :admin_auth
  end

  scope "/", StarWarsAPI do
    pipe_through :api

    get "/", HealthCheckController, :index
    get "/v1", HealthCheckController, :index
  end

  scope "/v1", StarWarsAPI.V1 do
    pipe_through :api

    resources "/planets", PlanetController, only: [:index, :show], as: :v1_planet
    resources "/movies", MovieController, only: [:index, :show], as: :v1_movie
  end

  scope "/v1", StarWarsAPI.V1 do
    pipe_through :api
    pipe_through :admin

    resources "/planets", PlanetController, only: [:delete], as: :v1_planet
  end

  defp admin_auth(conn, _opts) do
    required_password =
      Application.get_env(:star_wars, StarWarsAPI.Endpoint)[
        :admin_password
      ]

    case Plug.BasicAuth.parse_basic_auth(conn) do
      {"admin", input_password} ->
        if input_password == required_password do
          conn
        else
          conn
          |> Plug.BasicAuth.request_basic_auth()
          |> put_status(401)
          |> put_view(StarWarsAPI.ErrorView)
          |> render("401.json")
          |> halt()
        end

      _ ->
        conn
        |> Plug.BasicAuth.request_basic_auth()
        |> put_status(401)
        |> put_view(StarWarsAPI.ErrorView)
        |> render("401.json")
        |> halt()
    end
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
