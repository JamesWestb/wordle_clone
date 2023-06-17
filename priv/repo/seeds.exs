# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WordleClone.Repo.insert!(%WordleClone.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Ecto.Query, warn: false

alias WordleClone.Repo
alias WordleClone.WordBank.Word

words = WordList.getStream!() |> Enum.filter(& String.length(&1) == 5)

Enum.each(words, &WordleClone.Repo.insert!(%Word{name: &1}))

game_solutions = Application.get_env(:wordle_clone, :game_solutions)

Repo.update_all(
  from(word in Word,
    where: word.name in ^game_solutions
  ),
  set: [game_solution: true]
)
