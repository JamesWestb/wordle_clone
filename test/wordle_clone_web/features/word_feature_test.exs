defmodule WordleCloneWeb.WordFeatureTest do
  use WordleCloneWeb.FeatureCase, async: false

  import WordleClone.Factory

  alias WordleCloneWeb.Endpoint
  alias WordleCloneWeb.Router.Helpers, as: Routes

  test "renders marker", %{session: session} do
    session
    |> visit(Routes.word_index_path(Endpoint, :index))

    Process.sleep(10000)
    # |> assert_has(Query.css("#row_1", count: 1))
  end
end
