defmodule WordleCloneWeb.WordLive.Index do
  use WordleCloneWeb, :live_view

  alias Ecto.Changeset
  alias WordleClone.GameUtilities
  alias WordleClone.Guesses
  alias WordleClone.WordBank

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(answer: WordBank.get_game_answer(153).name |> String.graphemes())
    |> assign(input_cell_backgrounds: %{})
    |> assign(changeset: Guesses.guess_changeset(%{}))
    |> assign(input_disabled: false)
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
  def handle_event("keydown", %{"key" => "Enter"}, %{assigns: %{changeset: changeset}} = socket) do
    case get_error(changeset) do
      nil -> submit_guess(socket, changeset)
      "not in word bank" -> push_info_text_animation(socket, :not_in_database)
      _ -> push_info_text_animation(socket, :invalid_length)
    end
  end

  def handle_event(
        "keydown",
        %{"key" => "Backspace"},
        %{assigns: %{changeset: changeset}} = socket
      ) do
    socket |> assign(changeset: GameUtilities.pop_guess_list(changeset)) |> noreply()
  end

  def handle_event(
        "keydown",
        %{"key" => key},
        %{assigns: %{input_disabled: input_disabled}} = socket
      ) do
    if Regex.match?(~r/^[a-zA-Z]$/, key) && !input_disabled do
      handle_guess_input(socket, key)
    else
      socket |> assign(input_disabled: true) |> noreply()
    end
  end

  def handle_event("keyup", _, socket), do: socket |> assign(input_disabled: false) |> noreply()

  def handle_event(
        "background-change",
        thing,
        %{assigns: %{input_cell_backgrounds: input_cell_backgrounds}} = socket
      ) do
    socket
    |> assign(input_cell_backgrounds: Map.merge(input_cell_backgrounds, thing))
    |> noreply()
  end

  defp handle_guess_input(%{assigns: %{changeset: changeset}} = socket, key) do
    if find_error(changeset, "must be five characters") ||
         find_error(changeset, "must contain at least one guess") do
      socket
      |> assign(changeset: GameUtilities.append_guess_list(changeset, key))
      |> push_input_animation()
      |> noreply()
    else
      noreply(socket)
    end
  end

  defp submit_guess(%{assigns: %{answer: answer}} = socket, changeset) do
    if GameUtilities.current_guess(changeset) == answer do
      push_info_text_animation(socket, :correct)
    else
      socket
      |> assign(changeset: GameUtilities.initiate_new_guess(changeset))
      |> push_event("show-text-box", %{
        validation: nil,
        row: row(changeset.changes),
        answer: socket.assigns.answer
      })
      |> noreply()
    end
  end

  defp push_info_text_animation(
         %{assigns: %{changeset: changeset}} = socket,
         validation_message
       ) do
    socket
    |> push_event("show-text-box", %{
      validation: validation_message,
      row: row(changeset.changes),
      answer: socket.assigns.answer
    })
    |> noreply()
  end

  defp push_input_animation(%{assigns: %{changeset: changeset}} = socket) do
    row = map_size(changeset.changes) - 1
    column = length(GameUtilities.current_guess(changeset)) - 1

    socket
    |> push_event("animate-input-cell", %{
      coordinates: GameUtilities.stringify_cell_indices(row, column)
    })
  end

  defp get_error(%Changeset{valid?: true}), do: nil

  defp get_error(%Changeset{errors: [guess: {error_message, []}]}), do: error_message

  defp find_error(changeset, error_message) do
    Enum.find(changeset.errors, fn {_field, message} ->
      message == {error_message, []}
    end)
  end

  defp row(changes) when changes == %{}, do: 0
  defp row(changes), do: map_size(changes) - 1
end
