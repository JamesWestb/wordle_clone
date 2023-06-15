defmodule WordleClone.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :name, :string

      timestamps()
    end
  end
end
