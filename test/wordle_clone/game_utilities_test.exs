defmodule WordleClone.GameUtilitiesTest do
  use WordleClone.DataCase, async: true

  import WordleClone.Factory

  alias Ecto.Changeset
  alias WordleClone.GameUtilities
  alias WordleClone.Guesses

  describe "find_input_cell_value/2" do
    setup do
      %{
        changeset:
          Guesses.guess_changeset(%{
            guess_0: ["v", "a", "l", "i", "d"],
            guess_1: ["w", "o", "r", "l", "d"],
            guess_2: ["t", "w", "i", "c", "e"]
          })
      }
    end

    test "returns an alphabetical character when when the indices match a guess", %{
      changeset: changeset
    } do
      cell_indices_1 = "input_cell_1-2"
      cell_indices_2 = "input_cell_2-0"

      assert "R" == GameUtilities.find_input_cell_value(cell_indices_1, changeset)
      assert "T" == GameUtilities.find_input_cell_value(cell_indices_2, changeset)
    end

    test "returns an empty string when the indices do not match a guess", %{
      changeset: changeset
    } do
      empty_cell_indices = ["input_cell_4-3", "input_cell_5-0"]

      Enum.map(
        empty_cell_indices,
        &(&1 |> GameUtilities.find_input_cell_value(changeset) |> assert_empty_string())
      )
    end
  end

  describe "append_guess_list/2" do
    setup do
      insert(:word, name: "valid")

      %{}
    end

    test "creates guess_0 when there are no changes" do
      changeset = Guesses.guess_changeset(%{})
      current_guess = 0

      assert %Changeset{changes: %{guess_0: ["v"]}} =
               GameUtilities.append_guess_list(changeset, "v", current_guess)
    end

    test "appends elements to guess" do
      changeset = Guesses.guess_changeset(%{guess_0: ["v"]})
      current_guess = 0

      updated_changeset_1 = GameUtilities.append_guess_list(changeset, "a", current_guess)

      updated_changeset_2 =
        GameUtilities.append_guess_list(updated_changeset_1, "l", current_guess)

      assert %Changeset{changes: %{guess_0: ["v", "a"]}} = updated_changeset_1
      assert %Changeset{changes: %{guess_0: ["v", "a", "l"]}} = updated_changeset_2
    end

    test "appends elements to changes after guess_0" do
      guess_0 = ["v", "a", "l", "i", "d"]
      guess_1 = ["w", "o", "r", "l", "d"]
      current_guess = 2

      changeset =
        Guesses.guess_changeset(%{guess_0: guess_0, guess_1: guess_1, guess_2: ["t", "w"]})

      assert %Changeset{
               changes: %{guess_0: ^guess_0, guess_1: ^guess_1, guess_2: ["t", "w", "i"]}
             } = GameUtilities.append_guess_list(changeset, "i", current_guess)
    end
  end

  defp assert_empty_string(string), do: assert(byte_size(string) == 0)
end
