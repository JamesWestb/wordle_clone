defmodule WordleCloneWeb.WordFeatureTest do
  use WordleCloneWeb.FeatureCase, async: false
  use Phoenix.VerifiedRoutes,
    endpoint: WordleCloneWeb.Endpoint,
    router: WordleCloneWeb.Router

  import WordleClone.Factory

  setup do
    word_1 = insert(:word, id: 200, name: "valid", game_solution: true)
    word_2 = insert(:word, id: 201, name: "world", game_solution: false)

    correct_guess = String.graphemes(word_1.name)
    incorrect_guess = String.graphemes(word_2.name)

    %{correct_guess: correct_guess, incorrect_guess: incorrect_guess}
  end

  describe "submit guess, input cells" do
    test "displays invalid length message", %{
      session: session,
      correct_guess: [_ | invalid_length_guess]
    } do
      session
      |> visit_play_path()
      |> input_guess(invalid_length_guess)
      |> assert_text(Query.css("#info_text_box"), "Not enough letters")
    end

    test "displays invalid length message when no guess has been made", %{session: session} do
      session
      |> visit_play_path()
      |> Wallaby.Browser.send_keys([:enter])
      |> assert_text(Query.css("#info_text_box"), "Not enough letters")
    end

    test "displays invalid data message when word does not exist in database", %{session: session} do
      session
      |> visit_play_path()
      |> input_guess(["t", "h", "i", "n", "g"])
      |> assert_text(Query.css("#info_text_box"), "Not in word list")
    end

    test "displays correct guess message", %{session: session, correct_guess: correct_guess} do
      session
      |> visit_play_path()
      |> input_guess(correct_guess)
      |> assert_text(Query.css("#info_text_box"), "Genius")
    end

    test "animates guess submit", %{session: session, correct_guess: correct_guess} do
      session
      |> visit_play_path()
      |> input_guess(correct_guess)
      |> assert_has(Query.css(".flip-cell"))
    end

    test "index-dependent colored backgrounds for correct letters", %{
      session: session,
      incorrect_guess: incorrect_guess
    } do
      visit_play_path(session)

      assert_has(session, Query.css("#row_0 .bg-transparent", count: 5))

      input_guess(session, incorrect_guess)

      Enum.each(0..2, fn index ->
        assert_has(session, Query.css("#input_cell_0-#{index}.bg-incorrect-guess"))
      end)

      assert_has(session, Query.css("#input_cell_0-3.bg-incorrect-index"))
      assert_has(session, Query.css("#input_cell_0-4.bg-correct-index"))
    end

    test "backgrounds do not change", %{
      session: session,
      correct_guess: correct_guess,
      incorrect_guess: incorrect_guess
    } do
      visit_play_path(session)

      assert_has(session, Query.css("#row_0 .bg-transparent", count: 5))

      input_guess(session, incorrect_guess)

      assert_has(session, Query.css("#row_0 .bg-incorrect-guess", count: 3))
      assert_has(session, Query.css("#row_0 .bg-incorrect-index", count: 1))
      assert_has(session, Query.css("#row_0 .bg-correct-index", count: 1))

      input_guess(session, correct_guess, 1)

      assert_has(session, Query.css("#row_0 .bg-incorrect-guess", count: 3))
      assert_has(session, Query.css("#row_0 .bg-incorrect-index", count: 1))
      assert_has(session, Query.css("#row_0 .bg-correct-index", count: 1))
    end
  end

  describe "submit guess, keyboard cells" do
    test "updates keyboard background with guess index", %{
      session: session,
      correct_guess: correct_guess,
      incorrect_guess: incorrect_guess
    } do
      word = insert(:word, name: "angel", game_solution: false)
      incorrect_guess_2 = String.graphemes(word.name)

      visit_play_path(session)

      input_guess(session, incorrect_guess)

      Enum.each(["w", "o", "r"], fn value ->
        assert_has(session, Query.css("#keyboard_cell_#{value}.bg-incorrect-guess"))
      end)

      assert_has(session, Query.css("#keyboard_cell_l.bg-incorrect-index"))
      assert_has(session, Query.css("#keyboard_cell_d.bg-correct-index"))

      input_guess(session, incorrect_guess_2, 1)

      Enum.each(["w", "o", "r"], fn value ->
        assert_has(session, Query.css("#keyboard_cell_#{value}.bg-incorrect-guess"))
      end)

      assert_has(session, Query.css("#keyboard_cell_l.bg-incorrect-index"))
      assert_has(session, Query.css("#keyboard_cell_d.bg-correct-index"))
    end
  end

  describe "game end" do
    # Process.sleep/1 is necessary because the LiveView is updated via a message sent from the client after a
    # timeout in the guessSubmitAnimation hook. Consider exploring methods to override timeout in the test environment
    test "redirects when six guesses are submitted", %{
      session: session,
      incorrect_guess: incorrect_guess
    } do
      visit_play_path(session)

      Enum.each(0..5, fn index ->
        input_guess(session, incorrect_guess, index)
        Process.sleep(2000)
      end)

      assert_has(session, Query.css("#game_lose_header"))
    end

    test "redirects when a correct guess is submitted", %{
      session: session,
      correct_guess: correct_guess
    } do
      visit_play_path(session)

      input_guess(session, correct_guess)

      assert_has(session, Query.css("#game_win_header"))
    end
  end

  defp input_guess(session, guess, row \\ 0) do
    Enum.each(0..(length(guess) - 1), fn index ->
      input_value = guess |> Enum.at(index)

      send_keys(session, [input_value])
    end)

    Wallaby.Browser.send_keys(session, [:enter])
  end

  defp visit_play_path(session), do: visit(session, ~p"/play")
end
