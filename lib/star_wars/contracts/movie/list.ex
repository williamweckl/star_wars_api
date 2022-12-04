defmodule StarWars.Contracts.Movie.List do
  @moduledoc """
  Input pattern necessary to perform a movie list.

  ## Fields:

  - `page` :: Used to paginate.
  - `page_size` :: Used to paginate.
  - `title` :: Used to filter.
  """

  use CleanArchitecture.Contracts.List

  embedded_schema do
    pagination_schema_fields()
    field :title, :string
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, pagination_fields() ++ [:title])
    |> put_default_pagination_changes()
    |> validate_required(pagination_fields() ++ [])
    |> validate_pagination()
  end
end
