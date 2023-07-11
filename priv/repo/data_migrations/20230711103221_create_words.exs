defmodule WordleClone.Repo.Migrations.CreateWords do
  use Ecto.Migration

  alias WordleClone.Repo

  def up do
    words = WordList.getStream!() |> Enum.filter(&(String.length(&1) == 5))

    Enum.each(words, &Repo.insert!(%Word{name: &1}))

    game_solutions = Application.get_env(:wordle_clone, :game_solutions)

    Repo.update_all(
      from(word in Word,
        where: word.name in ^game_solutions
      ),
      set: [game_solution: true]
    )
  end
end
