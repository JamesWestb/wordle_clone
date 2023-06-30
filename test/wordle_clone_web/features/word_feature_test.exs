defmodule WordleCloneWeb.WordFeatureTest do
  use WordleCloneWeb.FeatureCase, async: false

  import WordleClone.Factory

  alias WordleCloneWeb.Endpoint
  alias WordleCloneWeb.Router.Helpers, as: Routes

  setup do
    word = insert(:word, id: 200, name: "valid", game_solution: true)
    guess = ["v", "a", "l", "i", "d"]

    %{word: word, guess: guess}
  end

  # WRITE DESCRIBE BLOCK

  test "displays invalid length message", %{session: session, guess: [_ | invalid_length_guess]} do
    session
    |> visit(Routes.word_index_path(Endpoint, :index))
    |> input_guess(invalid_length_guess)
    |> assert_text(Query.css("#info_text_box"), "Not enough letters")
  end

  test "displays invalid length message when no guess has been made", %{session: session} do
    session
    |> visit(Routes.word_index_path(Endpoint, :index))
    |> Wallaby.Browser.send_keys([:enter])
    |> assert_text(Query.css("#info_text_box"), "Not enough letters")
  end

  test "displays invalid data message when word does not exist in database", %{session: session} do
    session
    |> visit(Routes.word_index_path(Endpoint, :index))
    |> input_guess(["w", "o", "r", "l", "d"])
    |> assert_text(Query.css("#info_text_box"), "Not in word list")
  end

  test "displays correct guess message", %{session: session, guess: guess} do
    session
    |> visit(Routes.word_index_path(Endpoint, :index))
    |> input_guess(guess)
    |> assert_text(Query.css("#info_text_box"), "Genius")
  end

  defp input_guess(session, guess) do
    Enum.each(0..length(guess) - 1, fn index ->
      input_value = guess |> Enum.at(index)

      fill_in(session, Query.text_field("input_cell_0-#{index}"), with: input_value)
    end)

    Wallaby.Browser.send_keys(session, [:enter])
  end
end
