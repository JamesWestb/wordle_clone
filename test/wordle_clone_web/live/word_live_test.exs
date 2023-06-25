defmodule WordleCloneWeb.WordLiveTest do
  use WordleCloneWeb.ConnCase

  import WordleClone.Factory

  import Phoenix.LiveViewTest

  describe "Index" do
    setup do
      word = insert(:word, name: "valid", game_solution: true)

      %{word: word}
    end

    test "populates each text input cell", %{conn: conn} do
      {:ok, index_live, html} = live(conn, Routes.word_index_path(conn, :index))

      render_keyup(index_live, "keyup", %{"key" => "v"}) |> IO.inspect()

      assert index_live |> element("#input_cell_0_0") |> has_element?()

      assert index_live |> element("#input_cell_0_0 input[value=\"v\"]") |> has_element?()
    end
  end
end
