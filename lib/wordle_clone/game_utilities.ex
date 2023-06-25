defmodule WordleClone.GameUtilities do
  alias Ecto.Changeset
  alias WordleClone.Guesses

  def find_input_cell_value(cell_indices, changeset) do
    {row_index, column_index} = split_indices(cell_indices)

    case Changeset.get_change(changeset, guess_key(row_index)) do
      nil -> ""
      guess -> find_column_value(String.to_integer(column_index), guess)
    end
  end

  defp guess_key(row_index), do: ("guess_" <> row_index) |> String.to_atom()

  defp find_column_value(column_index, guess) do
    if column_index >= length(guess) do
      ""
    else
      List.to_tuple(guess) |> elem(column_index) |> String.upcase()
    end
  end

  defp split_indices(cell_indices) do
    [row_index, column_index] = String.split(cell_indices, "-")

    {row_index, column_index}
  end

  def append_guess_list(changeset, new_character) do
    guess_key = current_guess(changeset.changes)

    case guess_key do
      nil ->
        Guesses.guess_changeset(%{:guess_0 => [new_character]})

      _ ->
        guess_list = Changeset.get_change(changeset, guess_key)
        update_params = guess_list ++ [new_character]

        next_key = guess_key("#{Enum.count(changeset.changes)}")
        changes = Map.merge(changeset.changes, %{next_key => [new_character]})

        Guesses.guess_changeset(
          if changeset.valid?,
            do: changes,
            else: Map.merge(changeset.changes, %{guess_key => update_params})
        )
    end
  end

  defp current_guess(changes) when changes == %{}, do: nil
  defp current_guess(changes), do: guess_key("#{Enum.count(changes) - 1}")
end
