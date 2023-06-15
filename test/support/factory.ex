defmodule WordleClone.Factory do
  use ExMachina.Ecto, repo: WordleClone.Repo

  use WordleClone.WordBank.WordFactory
end
