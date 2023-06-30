defmodule WordleClone.WordBank do
  import Ecto.Query, warn: false

  alias WordleClone.Repo
  alias WordleClone.WordBank.Word

  def list_words do
    Repo.all(Word)
  end

  def get_word!(id), do: Repo.get!(Word, id)

  def get_game_answer(last_used_id) do
    from(word in Word,
      where: word.id > ^last_used_id and word.game_solution == true,
      order_by: [asc: word.id],
      limit: 1
    )
    |> Repo.one()
  end

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
    string = word_guess |> List.foldl("", &(&2 <> &1))

    from(word in Word,
      where: word.name == ^string
    )
    |> Repo.exists?()
  end
end
