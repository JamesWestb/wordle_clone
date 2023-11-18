defmodule WordleClone.GuessesTest do
  use WordleClone.DataCase, async: true

  import WordleClone.Factory

  alias Ecto.Changeset
  alias WordleClone.Guesses

  describe "validations" do
    setup do
      %{word: insert(:word, name: "valid")}
    end

    test "validates names in database" do
      valid_changeset = Guesses.guess_changeset(%{guess_0: ["v", "a", "l", "i", "d"]})
      invalid_changeset = Guesses.guess_changeset(%{guess_0: ["w", "o", "r", "l", "d"]})

      assert valid_changeset.valid?
      assert_error(invalid_changeset, "not in word bank")
    end

    test "does not validate name in database for guesses shorter than five characters" do
      invalid_changeset = Guesses.guess_changeset(%{guess_0: ["i", "n", "v", "a"]})

      refute Keyword.get(invalid_changeset.errors, :guess) == {"not in word bank", []}
    end

    test "validates length" do
      invalid_changeset = Guesses.guess_changeset(%{guess_0: ["i", "n", "v", "a"]})

      assert_error(invalid_changeset, "must be five characters")
    end
  end

  defp assert_error(%Changeset{errors: errors}, message),
    do: assert(Keyword.get(errors, :guess) == {message, []})
end
