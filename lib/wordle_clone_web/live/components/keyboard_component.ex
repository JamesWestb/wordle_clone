defmodule WordleCloneWeb.KeyboardComponent do
  use WordleCloneWeb, :live_component

  alias WordleClone.GameUtilities
  alias WordleCloneWeb.WordView

  @impl true
  def update(%{id: id, keyboard_backgrounds: keyboard_backgrounds}, socket) do
    socket
    |> assign(:id, id)
    |> assign(:keyboard_backgrounds, keyboard_backgrounds)
    |> ok()
  end

  def render(assigns) do
    keyboard_rows = [
      ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
      ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
      ["enter", "z", "x", "c", "v", "b", "n", "m", "backspace"]
    ]

    ~H"""
    <div id={@id} phx-hook="keyboardCellClick" class="w-full h-full">
      <%= for keyboard_row <- keyboard_rows do %>
        <div class="flex justify-center gap-1 mb-1.5 w-full sm:h-full h-14">
          <%= for keycap_value <- keyboard_row do %>
            <.live_component
              module={WordleCloneWeb.KeyboardCellComponent}
              id={"keycap_#{keycap_value}"}
              keycap_value={keycap_value}
              keyboard_backgrounds={@keyboard_backgrounds}
            />
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end
