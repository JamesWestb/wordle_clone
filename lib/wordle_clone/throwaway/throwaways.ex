defmodule WordleClone.Throwaway.Throwaways do
  use Ecto.Schema
  import Ecto.Changeset

  schema "throwaways" do
    field :throwaway, :string

    timestamps()
  end

  @doc false
  def changeset(throwaways, attrs) do
    throwaways
    |> cast(attrs, [:throwaway])
    |> validate_required([:throwaway])
  end
end
