defmodule StarWarsAPI.ErrorView do
  use StarWarsAPI, :view

  def render("429.json", _assigns) do
    %{errors: %{detail: "Too Many Requests"}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
