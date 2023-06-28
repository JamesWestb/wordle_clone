defmodule WordleClone.GameUtilities do
  alias Ecto.Changeset
  alias WordleClone.Guesses

  def find_input_cell_value(cell_indices, changeset) do
    {row_index, column_index} = split_indices(cell_indices)

    case Changeset.get_change(changeset, encode_guess_key(row_index)) do
      nil -> ""
      guess -> find_column_value(String.to_integer(column_index), guess)
    end
  end

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
    current_key = current_guess_key(changeset.changes)

    case current_key do
      nil ->
        Guesses.guess_changeset(%{:guess_0 => [new_character]})

      _ ->
        updated_guess = Changeset.get_change(changeset, current_key) ++ [new_character]
        new_changes = Map.merge(changeset.changes, %{current_key => updated_guess})

        Guesses.guess_changeset(new_changes)
    end
  end

  def initiate_new_guess(changeset) do
    next_key = encode_guess_key("#{Enum.count(changeset.changes)}")

    new_params = Map.merge(changeset.changes, %{next_key => []})

    Guesses.guess_changeset(new_params)
  end

  defp current_guess_key(changes) when changes == %{}, do: nil
  defp current_guess_key(changes), do: encode_guess_key("#{map_size(changes) - 1}")

  defp encode_guess_key(row_index), do: ("guess_" <> row_index) |> String.to_atom()
end
