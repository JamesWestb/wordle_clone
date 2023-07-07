defmodule WordleCloneWeb.WordFeatureTest do
  use WordleCloneWeb.FeatureCase, async: false

  import WordleClone.Factory

  alias WordleCloneWeb.Endpoint
  alias WordleCloneWeb.Router.Helpers, as: Routes

  setup do
    word_1 = insert(:word, id: 200, name: "valid", game_solution: true)
    word_2 = insert(:word, id: 201, name: "world", game_solution: false)

    correct_guess = String.graphemes(word_1.name)
    incorrect_guess = String.graphemes(word_2.name)

    %{correct_guess: correct_guess, incorrect_guess: incorrect_guess}
  end

  describe "submit guess" do
    test "displays invalid length message", %{
      session: session,
      correct_guess: [_ | invalid_length_guess]
    } do
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
      |> input_guess(["t", "h", "i", "n", "g"], 0)
      |> assert_text(Query.css("#info_text_box"), "Not in word list")
    end

    test "displays correct guess message", %{session: session, correct_guess: correct_guess} do
      session
      |> visit(Routes.word_index_path(Endpoint, :index))
      |> input_guess(correct_guess, 0)
      |> assert_text(Query.css("#info_text_box"), "Genius")
    end

    test "animates guess submit", %{session: session, correct_guess: correct_guess} do
      session
      |> visit(Routes.word_index_path(Endpoint, :index))
      |> input_guess(correct_guess, 0)
      |> assert_has(Query.css(".flip-cell"))
    end

    test "green background for correct letters at correct index", %{
      session: session,
      incorrect_guess: incorrect_guess
    } do
      visit(session, Routes.word_index_path(Endpoint, :index))

      assert_has(session, Query.css("#row_0 .bg-transparent", count: 5))

      input_guess(session, incorrect_guess, 0)

      Enum.each(0..3, fn index ->
        assert_has(session, Query.css("#input_cell_0-#{index}.bg-base-300"))
      end)

      assert_has(session, Query.css("#input_cell_0-4.bg-green-700"))
    end

    test "backgrounds do not change", %{
      session: session,
      correct_guess: correct_guess,
      incorrect_guess: incorrect_guess
    } do
      visit(session, Routes.word_index_path(Endpoint, :index))

      assert_has(session, Query.css("#row_0 .bg-transparent", count: 5))

      input_guess(session, incorrect_guess, 0)

      assert_has(session, Query.css("#row_0 .bg-base-300", count: 4))
      assert_has(session, Query.css("#row_0 .bg-green-700", count: 1))

      input_guess(session, correct_guess, 1)

      assert_has(session, Query.css("#row_0 .bg-base-300", count: 4))
      assert_has(session, Query.css("#row_0 .bg-green-700", count: 1))
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
