{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.configure(
  capture_log: true,
  formatters: [JUnitFormatter, ExUnit.CLIFormatter]
)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(StarWars.Repo, :manual)
