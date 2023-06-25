defmodule WordleClone.Guesses do
  alias Ecto.Changeset
  import Ecto.Changeset

  use Ecto.Schema

  @list_type {:array, :string}
  @guess_fields ~w(guess_0 guess_1 guess_2 guess_3 guess_4 guess_5)a

  embedded_schema do
    field :guess_0, @list_type
    field :guess_1, @list_type
    field :guess_2, @list_type
    field :guess_3, @list_type
    field :guess_4, @list_type
    field :guess_5, @list_type
  end

  def guess_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @guess_fields)
    |> validate_length()
  end

  defp validate_length(%Changeset{changes: changes} = changeset) do
    if Enum.all?(changes, fn {_, guess} -> guess_length(guess) end) do
      changeset
    else
      add_error(changeset, :name, "guess length must be five characters")
    end
  end

  # We pattern match here to avoid enumerating each guess in the changes
  defp guess_length([_, _, _, _, _]), do: true
  defp guess_length(_), do: false
end
