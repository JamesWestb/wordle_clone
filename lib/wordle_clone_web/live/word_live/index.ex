defmodule WordleCloneWeb.WordLive.Index do
  use WordleCloneWeb, :live_view

  alias WordleClone.WordBank
  alias WordleClone.WordBank.Word

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :words, list_words())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Word")
    |> assign(:word, WordBank.get_word!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Word")
    |> assign(:word, %Word{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Words")
    |> assign(:word, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    word = WordBank.get_word!(id)
    {:ok, _} = WordBank.delete_word(word)

    {:noreply, assign(socket, :words, list_words())}
  end

  defp list_words do
    WordBank.list_words()
  end
end
