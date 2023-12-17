defmodule WordleClone.GameUtilities do
  @keyboard_background_values %{"bg-incorrect-guess" => 1, "bg-incorrect-index" => 2, "bg-correct-index" => 3}

  alias Ecto.Changeset
  alias WordleClone.Guesses

  def find_input_cell_value("input_cell_" <> cell_indices, changeset) do
    {row_index, column_index} = split_indices(cell_indices)

    case Changeset.get_change(changeset, encode_guess_key(row_index)) do
      nil -> ""
      guess -> find_guess_value_at_index(String.to_integer(column_index), guess)
    end
  end

  defp find_guess_value_at_index(index, guess) do
    if index >= length(guess) do
      ""
    else
      List.to_tuple(guess) |> elem(index) |> String.upcase()
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
        existing_input_cell_backgrounds,
        new_input_cell_backgrounds,
        changeset
      ) do
    if new_input_cell_backgrounds == existing_input_cell_backgrounds do
      keyboard_backgrounds
    else
      process_incoming_guess_into_keyboard_backgrounds(new_input_cell_backgrounds, keyboard_backgrounds, changeset)
    end
  end

  defp process_incoming_guess_into_keyboard_backgrounds(input_cell_backgrounds, keyboard_backgrounds, changeset) do
    Enum.reduce(input_cell_backgrounds, keyboard_backgrounds, fn {cell_indices, _}, keyboard_backgrounds_acc ->

      letter_value =
        cell_indices
        |> find_input_cell_value(changeset)
        |> String.downcase()

      last_background = Map.get(keyboard_backgrounds, letter_value)
      new_background = Map.get(input_cell_backgrounds, cell_indices)

      updated_background =
        find_superior_value_background(last_background, new_background)

      Map.put(keyboard_backgrounds_acc, letter_value, updated_background)
    end)
  end

  defp find_superior_value_background(nil, new_background), do: new_background

  defp find_superior_value_background(last_background, new_background) do
    if Map.get(@keyboard_background_values, new_background) > Map.get(@keyboard_background_values, last_background) do
      new_background
    else
      last_background
    end
  end
end
