defmodule WordleCloneWeb.WordLiveTest do
  use WordleCloneWeb.ConnCase

  import WordleClone.Factory
  import Phoenix.LiveViewTest

  describe "guess input" do
    setup do
      insert(:word, name: "valid", game_solution: true, id: 200)
      word = insert(:word, name: "world", game_solution: false)
      incorrect_guess = String.graphemes(word.name)

      %{word: word, incorrect_guess: incorrect_guess}
    end

    test "populates each text input cell in a row", %{
      conn: conn,
      incorrect_guess: incorrect_guess
    } do
      {:ok, index_live, _html} = live(conn, Routes.word_index_path(conn, :index))

      Enum.each(0..4, fn index ->
        input_value = incorrect_guess |> Enum.at(index)

        render_keydown(index_live, "keydown", %{"key" => input_value})

        assert index_live
               |> element("#input_cell_0-#{index}[value=\"#{String.upcase(input_value)}\"]")
               |> has_element?()
      end)
    end

    test "does not populate input when a guess is completed", %{
      conn: conn,
      incorrect_guess: incorrect_guess
    } do
      {:ok, index_live, _html} = live(conn, Routes.word_index_path(conn, :index))

      input_guess(index_live, incorrect_guess)

      render_keydown(index_live, "keydown", %{"key" => "x"})

      refute index_live |> element("input[value=\"X\"]") |> has_element?()

      assert_input_values(index_live, incorrect_guess)
    end

    test "initiates a new guess", %{conn: conn, incorrect_guess: incorrect_guess} do
      {:ok, index_live, _html} = live(conn, Routes.word_index_path(conn, :index))

      input_guess(index_live, incorrect_guess)

      render_keydown(index_live, "keydown", %{"key" => "Enter"})
      render_keydown(index_live, "keydown", %{"key" => "x"})

      assert index_live |> element("#input_cell_1-0[value=\"X\"]") |> has_element?()

      assert_input_values(index_live, incorrect_guess)
    end

    test "removes characters from a guess", %{conn: conn, incorrect_guess: incorrect_guess} do
      {:ok, index_live, _html} = live(conn, Routes.word_index_path(conn, :index))

      input_guess(index_live, incorrect_guess)

      Enum.each(1..5, fn index ->
        {updated_guess, _} = Enum.split(incorrect_guess, index * -1)

        render_keydown(index_live, "keydown", %{"key" => "Backspace"})

        assert_input_values(index_live, updated_guess)
      end)
    end

    test "does not remove characters from the previous guess", %{
      conn: conn,
      incorrect_guess: incorrect_guess
    } do
      {:ok, index_live, _html} = live(conn, Routes.word_index_path(conn, :index))

      input_guess(index_live, incorrect_guess)

      render_keydown(index_live, "keydown", %{"key" => "Enter"})
      render_keydown(index_live, "keydown", %{"key" => "x"})

      render_keydown(index_live, "keydown", %{"key" => "Backspace"})

      refute index_live |> element("input[value=\"X\"]") |> has_element?()

      render_keydown(index_live, "keydown", %{"key" => "Backspace"})

      assert_input_values(index_live, incorrect_guess)
    end
  end

  describe "guess submit" do
    setup do
      word_1 = insert(:word, name: "valid", game_solution: true, id: 200)
      word_2 = insert(:word, name: "world", game_solution: false)

      correct_guess = String.graphemes(word_1.name)
      incorrect_guess = String.graphemes(word_2.name)

      %{words: [word_1, word_2], correct_guess: correct_guess, incorrect_guess: incorrect_guess}
    end
  end

  defp input_guess(live, guess) do
    Enum.each(0..4, fn index ->
      input_value = guess |> Enum.at(index)

      render_keydown(live, "keydown", %{"key" => input_value})
    end)
  end

  defp assert_input_values(live, guess) do
    Enum.each(0..4, fn index ->
      input_value = index_value(guess, index)

      assert live
             |> element("#input_cell_0-#{index}[value=\"#{String.upcase(input_value)}\"]")
             |> has_element?()
    end)
  end

  defp index_value(guess, index) do
    case Enum.at(guess, index) do
      nil -> ""
      value -> value
    end
  end
end
