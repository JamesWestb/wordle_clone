defmodule WordleClone.WordBank do
  import Ecto.Query, warn: false

  alias WordleClone.Repo
  alias WordleClone.WordBank.Word

  def list_words do
    Repo.all(Word)
  end

  def get_word!(id), do: Repo.get!(Word, id)

  def create_word(attrs \\ %{}) do
    %Word{}
    |> Word.changeset(attrs)
    |> Repo.insert()
  end

  def update_word(%Word{} = word, attrs) do
    word
    |> Word.changeset(attrs)
    |> Repo.update()
  end

  def delete_word(%Word{} = word) do
    Repo.delete(word)
  end

  def change_word(%Word{} = word, attrs \\ %{}) do
    Word.changeset(word, attrs)
  end

  def word_exists?(word_guess) do
    string =  word_guess |> List.foldl("", &(&2 <> &1))

    from(word in Word,
      where: word.name == ^string
    )
    |> Repo.exists?()
  end
end
