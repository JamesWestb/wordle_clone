defmodule WordleClone.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :wordle_clone

  def migrate do
    load_app()

    for repo <- repos() do
      path = Ecto.Migrator.migrations_path(repo)
      run_migrations(repo, path)
    end
  end

  def migrate_data do
    load_app()

    for repo <- repos() do
      path = Ecto.Migrator.migrations_path(repo, "data_migrations")
      run_migrations(repo, path)
    end
  end

  defp run_migrations(repo, path) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, path, :up, all: true))
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
