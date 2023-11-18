defmodule WordleCloneWeb.WordLive.GameOverComponent do
  use WordleCloneWeb, :live_component
  use Phoenix.VerifiedRoutes,
    endpoint: WordleCloneWeb.Endpoint,
    router: WordleCloneWeb.Router

  @impl true
  def update(%{title: title, game_win: game_win, answer: answer}, socket) do
    socket
    |> assign(:title, title)
    |> assign(:game_win, game_win)
    |> assign(:answer, answer)
    |> ok()
  end

  @impl true
  def handle_event("keydown", %{"key" => "Enter"}, socket) do
    socket
    |> push_redirect(to: ~p"/play")
    |> noreply()
  end

  def handle_event("keydown", _params, socket), do: noreply(socket)
end
