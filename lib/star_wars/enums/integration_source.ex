defmodule StarWars.Enums.IntegrationSource do
  @moduledoc """
  The integration source is used to know from where the registered entity came from in case of registered by an external integration.

  A planet for example, is registered only by an integration with another API. This ENUM represents this API.

  The entity source has an identifier and an URL.

  We can have other sources in the future like for example a manual input. In this case, the source would be manual input and the URL would be empty.
  """

  use EctoEnum,
    star_wars_public_api: "star_wars_public_api"

  @doc """
  Returns the default integration source.

  ## Examples
      iex> StarWars.Enums.IntegrationSource.default()
      :star_wars_public_api
  """
  def default, do: :star_wars_public_api

  @doc """
  Returns the integration source adapter according to the informed integration source.

  ## Examples
      iex> StarWars.Enums.IntegrationSource.get_adapter(:star_wars_public_api)
      StarWars.IntegrationSource.Adapters.StarWarsPublicAPI

      iex> StarWars.Enums.IntegrationSource.get_adapter(:mock)
      StarWars.IntegrationSource.Adapters.Mock
  """
  def get_adapter(:star_wars_public_api),
    do: StarWars.IntegrationSource.Adapters.StarWarsPublicAPI

  def get_adapter(:mock), do: StarWars.IntegrationSource.Adapters.Mock
end
