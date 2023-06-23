defmodule WordleCloneWeb.WordLive.Index do
  use WordleCloneWeb, :live_view

  alias WordleClone.GameUtilities
  alias WordleClone.WordBank
  alias WordleClone.WordBank.Word
  alias WordleClone.Guesses

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(changeset: Guesses.guess_changeset(%{}))
    |> ok()
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket
    |> apply_action(socket.assigns.live_action, params)
    |> noreply()
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Wordle Clone")
  end

  @impl true
  def handle_event("keyup", %{"key" => "Meta"}, socket), do: noreply(socket)

  def handle_event("keyup", %{"key" => key}, %{assigns: %{changeset: changeset}} = socket) do
    socket
    |> assign(changeset: GameUtilities.append_guess_list(changeset, key))
    |> noreply()
  end
end
