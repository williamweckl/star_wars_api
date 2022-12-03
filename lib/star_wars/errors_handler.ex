defmodule StarWars.ErrorsHandler do
  @moduledoc """
  Module used to handle errors triggered by the application.

  Since this is just a challenge, these errors are just logged.

  In the real world, it would be necessary to use some error tracking tool like Sentry, Rollbar, etc...

  This module would be a wrapper of these external tools.
  """

  require Logger

  @doc """
  Logs the error.
  """
  def report_error(module, function_name, error, stacktrace) do
    Logger.log(:error, error, module: module, function_name: function_name)
    Logger.log(:error, stacktrace, module: module, function_name: function_name)
  end
end
