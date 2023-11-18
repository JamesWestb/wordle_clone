defmodule WordleClone.Guesses do
  import Ecto.Changeset

  alias Ecto.Changeset
  alias WordleClone.WordBank

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
    |> validate_in_word_bank()
  end

  defp validate_length(%Changeset{changes: changes} = changeset) do
    if Enum.any?(changes) && Enum.all?(changes, fn {_, guess} -> length(guess) == 5 end) do
      changeset
    else
      add_error(changeset, :guess, "must be five characters")
    end
  end

  defp validate_in_word_bank(%Changeset{changes: changes} = changeset) do
    if Enum.all?(changes, fn {_, guess} -> word_exists?(guess) end) do
      changeset
    else
      add_error(changeset, :guess, "not in word bank")
    end
  end

  defp word_exists?(guess) when length(guess) == 5, do: WordBank.word_exists?(guess)
  defp word_exists?(_), do: true
end
