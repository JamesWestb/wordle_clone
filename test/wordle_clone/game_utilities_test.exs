defmodule WordleClone.GameUtilitiesTest do
  use ExUnit.Case, async: true

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
      cell_indices_1 = "1-2"
      cell_indices_2 = "2-0"

      assert "R" == GameUtilities.find_input_cell_value(cell_indices_1, changeset)
      assert "T" == GameUtilities.find_input_cell_value(cell_indices_2, changeset)
    end

    test "returns an empty string when the indices do not match a guess", %{
      changeset: changeset
    } do
      empty_cell_indices = ["4-3", "5-0"]

      Enum.map(
        empty_cell_indices,
        &(&1 |> GameUtilities.find_input_cell_value(changeset) |> assert_empty_string())
      )
    end
  end

  describe "append_guess_list/2" do
    test "creates guess_0 when there are no changes" do
      changeset = Guesses.guess_changeset(%{})

      assert %Changeset{changes: %{guess_0: ["v"]}} =
               GameUtilities.append_guess_list(changeset, "v")
    end

    test "appends elements to guess_0" do
      changeset = Guesses.guess_changeset(%{guess_0: ["v"]})

      updated_changeset_1 = GameUtilities.append_guess_list(changeset, "a")
      updated_changeset_2 = GameUtilities.append_guess_list(updated_changeset_1, "l")

      assert %Changeset{changes: %{guess_0: ["v", "a"]}} = updated_changeset_1
      assert %Changeset{changes: %{guess_0: ["v", "a", "l"]}} = updated_changeset_2
    end

    test "creates a new change when the existing changes are valid" do
      changeset = Guesses.guess_changeset(%{guess_0: ["v", "a", "l", "i"]})

      updated_changeset_1 = GameUtilities.append_guess_list(changeset, "d")
      updated_changeset_2 = GameUtilities.append_guess_list(updated_changeset_1, "n")

      assert %Changeset{changes: %{guess_0: ["v", "a", "l", "i", "d"]}, valid?: true} =
               updated_changeset_1

      assert %Changeset{
               changes: %{guess_0: ["v", "a", "l", "i", "d"], guess_1: ["n"]},
               valid?: false
             } = updated_changeset_2
    end

    test "appends elements to changes after guess_0" do
      guess_0 = ["v", "a", "l", "i", "d"]
      guess_1 = ["w", "o", "r", "l", "d"]

      changeset =
        Guesses.guess_changeset(%{guess_0: guess_0, guess_1: guess_1, guess_2: ["t", "w"]})

      assert %Changeset{
               changes: %{guess_0: ^guess_0, guess_1: ^guess_1, guess_2: ["t", "w", "i"]}
             } = GameUtilities.append_guess_list(changeset, "i")
    end
  end

  defp assert_empty_string(string), do: assert(byte_size(string) == 0)
end
