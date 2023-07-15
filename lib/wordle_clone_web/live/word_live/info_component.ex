defmodule WordleCloneWeb.WordLive.InfoComponent do
  use WordleCloneWeb, :live_component

  alias WordleCloneWeb.Router.Helpers, as: Routes

  @impl true
  def update(%{title: title}, socket) do
    socket
    |> assign(:title, title)
    |> ok()
  end

  @impl true
  def handle_event("keydown", %{"key" => "Meta"}, socket), do: noreply(socket)

  def handle_event("keydown", _params, socket) do
    socket
    |> push_redirect(to: Routes.word_index_path(socket, :index))
    |> noreply()
  end
end
