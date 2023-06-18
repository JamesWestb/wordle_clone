defmodule WordleClone.GameUtilities do
  def find_input_cell_value(cell_indices, guesses) do
    [row_index, column_index] = split_indices(cell_indices)

    case find_row_guess_value(row_index, guesses) do
      nil -> ""
      guess -> find_column_value(column_index, guess)
    end
  end

  defp find_row_guess_value(row_index, guesses) do
    case Enum.fetch(guesses, row_index) do
      {:ok, guess} -> guess
      :error -> nil
    end
  end

  defp find_column_value(column_index, guess) do
    case String.codepoints(guess) |> Enum.at(column_index) do
      nil -> ""
      letter -> letter
    end
  end

  defp split_indices(cell_indices) do
    String.split(cell_indices, "-") |> Enum.map(&String.to_integer/1)
  end

  def append_guess_list(guesses, new_character) when guesses == [], do: [new_character]
  def append_guess_list([new_guess | remaining_guesses], new_character), do: [new_guess <> new_character | remaining_guesses]
end
