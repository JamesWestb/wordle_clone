defmodule WordleClone.WordBank.Word do
  use Ecto.Schema
  import Ecto.Changeset

  schema "words" do
    field :name, :string
    field :game_solution, :boolean

    timestamps()
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:name, :game_solution])
    |> downcase_name()
    |> validate_required([:name])
    |> validate_length(:name, is: 5)
    |> validate_characters()
  end

  defp downcase_name(changeset) do
    case get_change(changeset, :name) do
      nil -> changeset
      name -> put_change(changeset, :name, String.downcase(name))
    end
  end

  defp validate_characters(changeset) do
    if Regex.match?(~r/\A[a-zA-Z]+\z/, changeset |> get_field(:name) |> to_string()) do
      changeset
    else
      add_error(changeset, :name, "contains non-alphabetical characters")
    end
  end
end
