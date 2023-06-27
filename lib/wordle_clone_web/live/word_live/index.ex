defmodule WordleCloneWeb.WordLive.Index do
  use WordleCloneWeb, :live_view

  alias WordleClone.GameUtilities
  alias WordleClone.Guesses
  alias WordleClone.WordBank
  alias Ecto.Changeset

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
  def handle_event("keydown", %{"key" => "Meta"}, socket), do: noreply(socket)

  def handle_event("keydown", %{"key" => "Enter"}, %{assigns: %{changeset: changeset}} = socket) do
    if find_error(changeset, "not in word bank") do
      socket
      |> push_event("show-text-box", %{})
      |> noreply()
    else
      socket
      |> assign(changeset: GameUtilities.initiate_new_guess(changeset))
      |> noreply()
    end
  end

  def handle_event("keydown", %{"key" => key}, %{assigns: %{changeset: changeset}} = socket) do
    socket
    |> assign(changeset: handle_guess_input(changeset, key))
    |> noreply()
  end

  defp handle_guess_input(changeset, key) do
    if find_error(changeset, "must be five characters")  || find_error(changeset, "must contain at least one guess") do
      GameUtilities.append_guess_list(changeset, key)

    else
      changeset
    end
  end

  defp find_error(changeset, error_message) do
    Enum.find(changeset.errors, fn {_field, message} ->
      message == {error_message, []}
    end)
  end
end
