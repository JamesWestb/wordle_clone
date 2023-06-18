defmodule WordleClone.GameUtilitiesTest do
  use ExUnit.Case, async: true

  alias WordleClone.GameUtilities

  describe "find_input_cell_value/2" do
    setup do
      %{guesses: ["valid", "guess", "third"]}
    end

    test "returns an alphabetical character when when the indices match a guess", %{
      guesses: guesses
    } do
      cell_indices_1 = "1-2"
      cell_indices_2 = "2-0"

      assert "e" == GameUtilities.find_input_cell_value(cell_indices_1, guesses)
      assert "t" == GameUtilities.find_input_cell_value(cell_indices_2, guesses)
    end

    test "returns an empty string when the indices do not match a guess", %{
      guesses: guesses
    } do
      empty_cell_indices = ["4-3", "5-0"]

      Enum.map(
        empty_cell_indices,
        &(&1 |> GameUtilities.find_input_cell_value(guesses) |> assert_empty_string())
      )
    end
  end

  describe "append_guess_list/2" do
    test "appends a character when the guess list is empty" do
      guesses = []
      new_character = "g"

      assert ["g"] == GameUtilities.append_guess_list(guesses, new_character)
    end

    test "appends a character to an incomplete guess" do
      guesses = ["gue", "valid"]
      new_character = "s"

      assert ["gues", "valid"] == GameUtilities.append_guess_list(guesses, new_character)
    end
  end

  defp assert_empty_string(string), do: assert(byte_size(string) == 0)
end
