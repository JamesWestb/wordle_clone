defmodule WordleCloneWeb.ThrowawaysLive.Index do
  use WordleCloneWeb, :live_view

  alias WordleClone.Throwaway
  alias WordleClone.Throwaway.Throwaways

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :throwaways_collection, list_throwaways())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Throwaways")
    |> assign(:throwaways, Throwaway.get_throwaways!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Throwaways")
    |> assign(:throwaways, %Throwaways{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Throwaways")
    |> assign(:throwaways, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    throwaways = Throwaway.get_throwaways!(id)
    {:ok, _} = Throwaway.delete_throwaways(throwaways)

    {:noreply, assign(socket, :throwaways_collection, list_throwaways())}
  end

  defp list_throwaways do
    Throwaway.list_throwaways()
  end
end
