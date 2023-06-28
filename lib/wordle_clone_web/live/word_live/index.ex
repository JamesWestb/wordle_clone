defmodule WordleCloneWeb.WordLive.Index do
  use WordleCloneWeb, :live_view

  alias Ecto.Changeset
  alias WordleClone.GameUtilities
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
  def handle_event("keydown", %{"key" => "Meta"}, socket), do: noreply(socket)

  def handle_event("keydown", %{"key" => "Enter"}, %{assigns: %{changeset: changeset}} = socket) do
    IO.inspect(get_error(changeset))

    case get_error(changeset) do
      nil -> socket |> assign(changeset: GameUtilities.initiate_new_guess(changeset)) |> noreply()
      "not in word bank" -> push_error_message(socket, "Not in word list")
      _ -> push_error_message(socket, "Not enough letters")
    end
  end

  def handle_event("keydown", %{"key" => key}, %{assigns: %{changeset: changeset}} = socket) do
    if Regex.match?(~r/^[a-zA-Z]$/, key) do
      socket
      |> assign(changeset: handle_guess_input(changeset, key))
      |> noreply()
    else
      noreply(socket)
    end
  end

  defp handle_guess_input(changeset, key) do
    if find_error(changeset, "must be five characters") ||
         find_error(changeset, "must contain at least one guess") do
      GameUtilities.append_guess_list(changeset, key)
    else
      changeset
    end
  end

  defp push_error_message(%{assigns: %{changeset: changeset}} = socket, message) do
    socket
    |> push_event("show-text-box", %{message: message, row: map_size(changeset.changes) - 1})
    |> noreply()
  end

  defp get_error(%Changeset{valid?: true}), do: nil

  defp get_error(%Changeset{errors: [guess: {error_message, []}]}), do: error_message

  defp find_error(changeset, error_message) do
    Enum.find(changeset.errors, fn {_field, message} ->
      message == {error_message, []}
    end)
  end
end
