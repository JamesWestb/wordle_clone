defmodule WordleCloneWeb.WordLive.Index do
  use WordleCloneWeb, :live_view

  use Phoenix.VerifiedRoutes,
    endpoint: WordleCloneWeb.Endpoint,
    router: WordleCloneWeb.Router

  alias Ecto.Changeset
  alias WordleClone.GameUtilities
  alias WordleClone.Guesses
  alias WordleClone.WordBank
  alias WordleCloneWeb.Router.Helpers, as: Routes

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(answer: WordBank.get_random_word().name |> String.graphemes())
    |> assign(input_cell_backgrounds: %{})
    |> assign(keyboard_backgrounds: %{})
    |> assign(changeset: Guesses.guess_changeset(%{}))
    |> assign(input_disabled: false)
    |> assign(game_win: false)
    |> assign(current_guess: 0)
    |> ok()
  end

  @impl true
  def handle_params(params, _url, %{assigns: %{live_action: live_action}} = socket) do
    socket
    |> apply_action(live_action, params)
    |> noreply()
  end

  defp apply_action(socket, action, _params) when action in [:index, :info],
    do: assign(socket, :page_title, "LiveView Wordle")

  defp apply_action(socket, :contact, _params), do: assign(socket, :page_title, "Contact")

  defp apply_action(socket, :game_over, _params), do: assign(socket, :page_title, "Game over!")

  @impl true
  def handle_event("keydown", %{"key" => "Enter"}, %{assigns: %{changeset: changeset}} = socket) do
    case get_error(changeset) do
      nil -> submit_guess(socket)
      "not in word bank" -> socket |> push_submit_animation(:not_in_database) |> noreply()
      _ -> socket |> push_submit_animation(:invalid_length) |> noreply()
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
        updated_input_cell_backgrounds,
        %{
          assigns: %{
            input_cell_backgrounds: input_cell_backgrounds,
            keyboard_backgrounds: keyboard_backgrounds,
            changeset: changeset,
            answer: answer
          }
        } = socket
      ) do
    empty_guess? = Enum.any?(changeset.changes, fn {_, guess} -> Enum.empty?(guess) end)
    current_guess = GameUtilities.current_guess(changeset)

    if current_guess == answer || (map_size(changeset.changes) > 5 && !empty_guess?) do
      socket
      |> assign(:game_win, current_guess == answer)
      |> assign(:live_action, :game_over)
      |> noreply()
    else
      socket
      |> assign(
        input_cell_backgrounds: Map.merge(input_cell_backgrounds, updated_input_cell_backgrounds)
      )
      |> assign(
        keyboard_backgrounds:
          GameUtilities.update_keyboard_backgrounds(
            keyboard_backgrounds,
            input_cell_backgrounds,
            updated_input_cell_backgrounds,
            changeset
          )
      )
      |> noreply()
    end
  end

  defp handle_guess_input(
         %{assigns: %{changeset: changeset, current_guess: current_guess}} = socket,
         key
       ) do
    if find_error(changeset, "must be five characters") ||
         find_error(changeset, "must contain at least one guess") do
      socket
      |> assign(changeset: GameUtilities.append_guess_list(changeset, key, current_guess))
      |> push_input_animation()
      |> noreply()
    else
      noreply(socket)
    end
  end

  defp submit_guess(
         %{assigns: %{answer: answer, changeset: changeset, current_guess: current_guess}} =
           socket
       ) do
    if GameUtilities.current_guess(changeset) == answer do
      socket
      |> push_submit_animation(:correct)
      |> noreply()
    else
      new_guess = current_guess + 1

      socket
      |> push_submit_animation(nil)
      |> assign(current_guess: new_guess)
      |> assign(changeset: GameUtilities.initiate_new_guess(changeset, new_guess))
      |> noreply()
    end
  end

  defp push_submit_animation(
         %{assigns: %{changeset: changeset, answer: answer}} = socket,
         validation_message
       ) do
    hook_attrs = %{
      row: row(changeset.changes),
      validation: validation_message,
      answer: answer
    }

    socket
    |> push_event("animate-validation-text", hook_attrs)
    |> push_event("animate-guess-submit", hook_attrs)
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
