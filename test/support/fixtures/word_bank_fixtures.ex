defmodule WordleClone.WordBankFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WordleClone.WordBank` context.
  """

  @doc """
  Generate a word.
  """
  def word_fixture(attrs \\ %{}) do
    {:ok, word} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> WordleClone.WordBank.create_word()

    word
  end
end
