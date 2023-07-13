defmodule WordleCloneWeb.WordLive.InfoComponent do
  use WordleCloneWeb, :live_component

  @impl true
  def update(%{title: title}, socket) do
    socket
    |> assign(:title, title)
    |> ok()
  end
end
