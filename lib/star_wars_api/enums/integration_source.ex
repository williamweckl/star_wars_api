defmodule StarWarsAPI.Enums.IntegrationSource do
  @moduledoc """
  The integration source is used to know from where the registered entity came from in case of registered by an external integration.

  A planet for example, is registered only by an integration with another API. This ENUM represents this API.

  The entity source has an identifier and an URL.

  We can have other sources in the future like for example a manual input. In this case, the source would be manual input and the URL would be empty.
  """

  @base_urls %{
    star_wars_public_api: "https://swapi.py4e.com"
  }
  @endpoints %{
    star_wars_public_api: %{
      planet: "api/planets/:id",
      planets: "api/planets"
    }
  }

  use EctoEnum,
    star_wars_public_api: "star_wars_public_api"

  @doc """
  Returns the default integration source.

  ## Examples
      iex> StarWarsAPI.Enums.IntegrationSource.default()
      :star_wars_public_api
  """
  def default, do: :star_wars_public_api

  @doc """
  Returns the base URL of the integration source by its ID.

  ## Examples
      iex> StarWarsAPI.Enums.IntegrationSource.base_url(:star_wars_public_api)
      "https://swapi.py4e.com"
  """
  def base_url(integration_source), do: @base_urls[integration_source]

  @doc """
  Returns the URL of the integration source planet endpoint by its ID.

  ## Examples
      iex> StarWarsAPI.Enums.IntegrationSource.planet_url(:star_wars_public_api, 1)
      "https://swapi.py4e.com/api/planets/1"

      iex> StarWarsAPI.Enums.IntegrationSource.planet_url(:star_wars_public_api, 123)
      "https://swapi.py4e.com/api/planets/123"

      iex> StarWarsAPI.Enums.IntegrationSource.planet_url(:star_wars_public_api, "xpto")
      "https://swapi.py4e.com/api/planets/xpto"
  """
  def planet_url(integration_source, id) do
    "#{base_url(integration_source)}/#{@endpoints[integration_source][:planet]}" |> String.replace(":id", "#{id}")
  end

  @doc """
  Returns the URL of the integration source planets endpoint by its ID.

  ## Examples
      iex> StarWarsAPI.Enums.IntegrationSource.planets_url(:star_wars_public_api)
      "https://swapi.py4e.com/api/planets"
  """
  def planets_url(integration_source) do
    "#{base_url(integration_source)}/#{@endpoints[integration_source][:planets]}"
  end
end
