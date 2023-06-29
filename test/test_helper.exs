{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()

{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, WordleCloneWeb.Endpoint.url())

Ecto.Adapters.SQL.Sandbox.mode(WordleClone.Repo, :manual)
