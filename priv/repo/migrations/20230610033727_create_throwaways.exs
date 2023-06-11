defmodule WordleClone.Repo.Migrations.CreateThrowaways do
  use Ecto.Migration

  def change do
    create table(:throwaways) do
      add :throwaway, :string

      timestamps()
    end
  end
end
