defmodule StarWars.ErrorsHandlerTest do
  use StarWars.DataCase

  import ExUnit.CaptureLog

  alias StarWars.ErrorsHandler

  describe "report_error/4" do
    test "logs the error and stacktrace" do
      {:current_stacktrace, stacktrace} = Process.info(self(), :current_stacktrace)

      assert capture_log(fn ->
               ErrorsHandler.report_error(
                 __MODULE__,
                 :test_logs_the_error,
                 "Some error happened!",
                 stacktrace
               )
             end) =~ "Some error happened!"

      assert capture_log(fn ->
               ErrorsHandler.report_error(
                 __MODULE__,
                 :test_logs_the_error,
                 "Some error happened!",
                 stacktrace
               )
             end) =~ "#{inspect(stacktrace)}"
    end
  end
end
