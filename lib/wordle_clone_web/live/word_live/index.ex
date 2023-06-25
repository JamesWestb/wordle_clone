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
  def handle_event("keyup", %{"key" => "Meta"}, socket), do: noreply(socket)

  def handle_event("keyup", %{"key" => key}, %{assigns: %{changeset: changeset}} = socket) do
    updated_changeset = GameUtilities.append_guess_list(changeset, key)

    socket
    |> check_word_bank(updated_changeset)
    |> assign(changeset: updated_changeset)
    |> noreply()
  end

  defp check_word_bank(socket, changeset) do
    IO.inspect(changeset)
    if in_word_bank?(changeset) do
      socket
    else
      IO.puts "-----------------------------"
      push_event(socket, "show-text-box", %{})
    end
  end

  defp in_word_bank?(%Changeset{valid?: true, changes: %{guess_0: guess_0}}), do: WordBank.word_exists?(guess_0)

  defp in_word_bank?(_), do: true
end
