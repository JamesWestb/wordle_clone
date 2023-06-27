defmodule WordleCloneWeb.WordLiveTest do
  use WordleCloneWeb.ConnCase

  import WordleClone.Factory
  import Phoenix.LiveViewTest

  describe "Index" do
    setup do
      word = insert(:word, name: "valid", game_solution: true)
      guess = ["v", "a", "l", "i", "d"]

      %{word: word, guess: guess}
    end

    test "populates each text input cell in a row", %{conn: conn, guess: guess} do
      {:ok, index_live, html} = live(conn, Routes.word_index_path(conn, :index))

      Enum.each(0..4, fn index ->
        input_value = guess |> Enum.at(index)

        render_keydown(index_live, "keydown", %{"key" => input_value})

        assert index_live
               |> element("#input_cell_0-#{index}[value=\"#{String.upcase(input_value)}\"]")
               |> has_element?()
      end)
    end

    test "does not populate input when a guess is completed", %{conn: conn, guess: guess} do
      {:ok, index_live, html} = live(conn, Routes.word_index_path(conn, :index))

      input_guess(index_live, guess)

      render_keydown(index_live, "keydown", %{"key" => "x"})

      refute index_live |> element("input[value=\"X\"]") |> has_element?()

      assert_input_values(index_live, guess)
    end

    test "initiates a new guess", %{conn: conn, guess: guess} do
      {:ok, index_live, html} = live(conn, Routes.word_index_path(conn, :index))

      input_guess(index_live, guess)

      render_keydown(index_live, "keydown", %{"key" => "Enter"})
      render_keydown(index_live, "keydown", %{"key" => "x"})

      assert index_live |> element("#input_cell_1-0[value=\"X\"]") |> has_element?()

      assert_input_values(index_live, guess)
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
      input_value = guess |> Enum.at(index)

      assert live
             |> element("#input_cell_0-#{index}[value=\"#{String.upcase(input_value)}\"]")
             |> has_element?()
    end)
  end
end
