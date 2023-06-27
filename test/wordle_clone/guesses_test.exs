defmodule WordleClone.GuessesTest do
  use WordleClone.DataCase, async: true

  import WordleClone.Factory

  alias WordleClone.Guesses

  describe "validations" do
    setup do  %{word: insert(:word, name: "valid")} end

    test "validates names exist in database" do
      valid_changeset = Guesses.guess_changeset(%{guess_0: ["v", "a", "l", "i", "d"]})
      invalid_changeset = Guesses.guess_changeset(%{guess_0: ["w", "o", "r", "l", "d"]})

      assert valid_changeset.valid?
      assert Keyword.get(invalid_changeset.errors, :guess) == {"not in word bank", []}
    end

    test "does not validate name exists for guesses shorter than five characters" do
      invalid_changeset = Guesses.guess_changeset(%{guess_0: ["i", "n", "v", "a"]})

      refute Keyword.get(invalid_changeset.errors, :guess) == {"not in word bank", []}
    end

    test "validates at least one guess" do
      invalid_guess = Guesses.guess_changeset(%{})

      assert Keyword.get(invalid_guess.errors, :guess) == {"must contain at least one guess", []}
    end

    test "validates length" do
      invalid_changeset = Guesses.guess_changeset(%{guess_0: ["i", "n", "v", "a"]})

      assert Keyword.get(invalid_changeset.errors, :guess) == {"must be five characters", []}
    end
  end
end
