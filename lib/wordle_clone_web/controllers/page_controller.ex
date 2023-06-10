defmodule WordleCloneWeb.PageController do
  use WordleCloneWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
