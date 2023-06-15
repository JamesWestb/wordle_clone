defmodule WordleClone.WordBankTest do
  use WordleClone.DataCase

  alias WordleClone.WordBank

  describe "words" do
    alias WordleClone.WordBank.Word

    import WordleClone.WordBankFixtures

    @invalid_attrs %{name: nil}

    test "list_words/0 returns all words" do
      word = word_fixture()
      assert WordBank.list_words() == [word]
    end

    test "get_word!/1 returns the word with given id" do
      word = word_fixture()
      assert WordBank.get_word!(word.id) == word
    end

    test "create_word/1 with valid data creates a word" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Word{} = word} = WordBank.create_word(valid_attrs)
      assert word.name == "some name"
    end

    test "create_word/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WordBank.create_word(@invalid_attrs)
    end

    test "update_word/2 with valid data updates the word" do
      word = word_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Word{} = word} = WordBank.update_word(word, update_attrs)
      assert word.name == "some updated name"
    end

    test "update_word/2 with invalid data returns error changeset" do
      word = word_fixture()
      assert {:error, %Ecto.Changeset{}} = WordBank.update_word(word, @invalid_attrs)
      assert word == WordBank.get_word!(word.id)
    end

    test "delete_word/1 deletes the word" do
      word = word_fixture()
      assert {:ok, %Word{}} = WordBank.delete_word(word)
      assert_raise Ecto.NoResultsError, fn -> WordBank.get_word!(word.id) end
    end

    test "change_word/1 returns a word changeset" do
      word = word_fixture()
      assert %Ecto.Changeset{} = WordBank.change_word(word)
    end
  end
end
