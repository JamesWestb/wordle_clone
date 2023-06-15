defmodule WordleCloneWeb.WordLiveTest do
  use WordleCloneWeb.ConnCase

  import WordleClone.Factory

  import Phoenix.LiveViewTest
  import WordleClone.WordBankFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_word(_) do
    word = word_fixture()
    %{word: word}
  end

  describe "Index" do
    setup [:create_word]

    test "lists all words", %{conn: conn, word: word} do
      {:ok, _index_live, html} = live(conn, Routes.word_index_path(conn, :index))

      assert html =~ "Listing Words"
      assert html =~ word.name
    end
  end
end
