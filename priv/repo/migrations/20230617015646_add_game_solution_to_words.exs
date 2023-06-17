defmodule WordleClone.Repo.Migrations.AddGameSolutionToWords do
  use Ecto.Migration

  def change do
    alter table(:words) do
      add :game_solution, :boolean, default: false, null: false
    end
  end
end
