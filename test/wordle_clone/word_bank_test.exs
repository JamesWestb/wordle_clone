defmodule WordleClone.WordBankTest do
  use WordleClone.DataCase, async: true

  import WordleClone.Factory

  alias WordleClone.WordBank
  alias WordleClone.WordBank.Word

  @invalid_attrs %{name: nil}

  describe "list_words/0" do
    test "returns all words" do
      word = insert(:word)

      assert WordBank.list_words() == [word]
    end
  end

  describe "get_word!/1" do
    test "returns the word with given id" do
      word = insert(:word)

      assert WordBank.get_word!(word.id) == word
    end
  end

  describe "create_word/1" do
    test "create_word/1 with valid data creates a word" do
      valid_attrs = %{name: "valid"}

      assert {:ok, %Word{} = word} = WordBank.create_word(valid_attrs)
      assert word.name == "valid"
    end

    test "create_word/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WordBank.create_word(@invalid_attrs)
    end

    test "validates characters" do
      invalid_attrs_list = [%{name: "name "}, %{name: "name_"}, %{name: "name1"}]

      Enum.map(invalid_attrs_list, fn invalid_attrs ->
        {:error, changeset} = WordBank.create_word(invalid_attrs)

        assert %{
                 name: ["contains non-alphabetical characters"]
               } = errors_on(changeset)
      end)
    end

    test "normalizes data" do
      upcased_attrs = %{name: "Valid"}

      assert {:ok, %Word{name: "valid"}} = WordBank.create_word(upcased_attrs)
    end
  end

  describe "update_word/2" do
    test "with valid data updates the word" do
      word = insert(:word)
      update_attrs = %{name: "other"}

      assert {:ok, %Word{} = updated_word} = WordBank.update_word(word, update_attrs)
      assert updated_word.name == "other"
    end

    test "with invalid data returns error changeset" do
      word = insert(:word)

      assert {:error, %Ecto.Changeset{}} = WordBank.update_word(word, @invalid_attrs)
      assert word == WordBank.get_word!(word.id)
    end
  end

  describe "delete_word/1" do
    test "delete_word/1 deletes the word" do
      word = insert(:word)

      assert {:ok, %Word{}} = WordBank.delete_word(word)
      assert_raise Ecto.NoResultsError, fn -> WordBank.get_word!(word.id) end
    end
  end

  describe "change_word/1" do
    test "returns a word changeset" do
      word = insert(:word)

      assert %Ecto.Changeset{} = WordBank.change_word(word)
    end
  end
end
