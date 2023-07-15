defmodule WordleCloneWeb.WordLive.GameOverComponent do
  use WordleCloneWeb, :live_component

  @impl true
  def update(%{title: title, game_win: game_win, answer: answer}, socket) do
    socket
    |> assign(:title, title)
    |> assign(:game_win, game_win)
    |> assign(:answer, answer)
    |> ok()
  end
end
