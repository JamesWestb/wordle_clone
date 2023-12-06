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

  def append_guess_list(changeset, new_character, current_guess) do
    current_key = encode_guess_key("#{current_guess}")

    case Changeset.get_change(changeset, current_key) do
      nil ->
        Guesses.guess_changeset(%{current_key => [new_character]})

      _ ->
        updated_guess = Changeset.get_change(changeset, current_key) ++ [new_character]
        new_changes = Map.merge(changeset.changes, %{current_key => updated_guess})

        Guesses.guess_changeset(new_changes)
    end
  end

  def pop_guess_list(changeset) do
    current_key = current_guess_key(changeset.changes)

    case current_key do
      nil ->
        changeset

      _ ->
        updated_guess = List.delete_at(Changeset.get_change(changeset, current_key), -1)
        new_changes = Map.merge(changeset.changes, %{current_key => updated_guess})

        Guesses.guess_changeset(new_changes)
    end
  end

  def initiate_new_guess(%Changeset{changes: changes}, next_guess) do
    next_guess_key = encode_guess_key("#{next_guess}")

    new_params = Map.merge(changes, %{next_guess_key => []})

    Guesses.guess_changeset(new_params)
  end

  def stringify_cell_indices(row_index, column_index), do: "#{row_index}-#{column_index}"

  def current_guess(changeset) do
    current_guess_key = current_guess_key(changeset.changes)

    Changeset.get_change(changeset, current_guess_key)
  end

  def current_guess_key(changes) when changes == %{}, do: nil
  def current_guess_key(changes), do: encode_guess_key("#{map_size(changes) - 1}")

  defp encode_guess_key(row_index), do: ("guess_" <> row_index) |> String.to_atom()

  def update_keyboard_backgrounds(
        keyboard_backgrounds,
        last_input_cell_backgrounds,
        new_input_cell_backgrounds,
        changeset
      ) do
    background_values = %{
      "bg-incorrect-guess" => 1,
      "bg-incorrect-index" => 2,
      "bg-correct-index" => 3
    }

    if new_input_cell_backgrounds == last_input_cell_backgrounds do
      keyboard_backgrounds
    else
      Enum.reduce(new_input_cell_backgrounds, keyboard_backgrounds, fn {cell_indices, _}, acc ->
        input_value = cell_indices |> find_input_cell_value(changeset) |> String.downcase()

        last_background = Map.get(keyboard_backgrounds, input_value)
        new_background = Map.get(new_input_cell_backgrounds, cell_indices)

        updated_background = greatest_background(last_background, new_background, background_values)

        Map.put(acc, input_value, updated_background)
      end)
    end
  end

  defp greatest_background(nil, new_background, _background_values), do: new_background

  defp greatest_background(last_background, new_background, background_values) do
    if Map.get(background_values, new_background) > Map.get(background_values, last_background) do
      new_background
    else
      last_background
    end
  end
end
