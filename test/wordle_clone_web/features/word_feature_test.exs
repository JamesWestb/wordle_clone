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

  describe "submit guess" do
    test "displays invalid length message", %{session: session, guess: [_ | invalid_length_guess]} do
      session
      |> visit(Routes.word_index_path(Endpoint, :index))
      |> input_guess(invalid_length_guess, 0)
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
      |> input_guess(["w", "o", "r", "l", "d"], 0)
      |> assert_text(Query.css("#info_text_box"), "Not in word list")
    end

    test "displays correct guess message", %{session: session, guess: guess} do
      session
      |> visit(Routes.word_index_path(Endpoint, :index))
      |> input_guess(guess, 0)
      |> assert_text(Query.css("#info_text_box"), "Genius")
    end

    test "animates guess submit", %{session: session, guess: guess} do
      session
      |> visit(Routes.word_index_path(Endpoint, :index))
      |> input_guess(guess, 0)
      |> assert_has(Query.css(".guess-submit"))
    end

    test "backgrounds do not change", %{session: session, guess: guess} do
      session
      |> visit(Routes.word_index_path(Endpoint, :index))

      refute_has(session, Query.css(".bg-base-300"))

      input_guess(session, guess, 0)

      assert_has(session, Query.css(".bg-base-300"))

      input_guess(session, ["w", "o", "r"])

      assert_has(session, Query.css(".bg-base-300"))
    end
  end

  defp input_guess(session, guess, row) do
    Enum.each(0..(length(guess) - 1), fn index ->
      input_value = guess |> Enum.at(index)

      fill_in(session, Query.text_field("input_cell_#{row}-#{index}"), with: input_value)
    end)

    Wallaby.Browser.send_keys(session, [:enter])
  end
end
