defmodule WordleCloneWeb.WordView do
  use WordleCloneWeb, :view

  def keyboard(keyboard_backgrounds) do
    keyboard_rows = [
      ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
      ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
      ["enter", "z", "x", "c", "v", "b", "n", "m", "backspace"]
    ]

    ~E"""
    <div id="keyboard" phx-hook="keyboardCellClick" class="w-full h-full">
      <%= for keyboard_row <- keyboard_rows do %>
        <div class="flex justify-center gap-1 mb-1.5 w-full sm:h-full h-14">
          <%= for value <- keyboard_row do %>
            <%= keyboard_cell(value, keyboard_backgrounds) %>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  defp keyboard_cell(value, _) when value == "backspace" do
    ~E"""
    <kbd id="<%= value %>" class="kbd kbd-lg text-slate-100 cursor-default rounded-md border-transparent bg-keyboard" phx-click="keydown" phx-value-key="Backspace">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-10 sm:w-7">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 9.75L14.25 12m0 0l2.25 2.25M14.25 12l2.25-2.25M14.25 12L12 14.25m-2.58 4.92l-6.375-6.375a1.125 1.125 0 010-1.59L9.42 4.83c.211-.211.498-.33.796-.33H19.5a2.25 2.25 0 012.25 2.25v10.5a2.25 2.25 0 01-2.25 2.25h-9.284c-.298 0-.585-.119-.796-.33z" />
      </svg>
    </kbd>
    """
  end

  defp keyboard_cell(value, _) when value == "enter" do
    ~E"""
    <kbd id="<%= value %>" class="kbd kbd-lg text-slate-100 cursor-default font-bold border-transparent rounded-md py-3 text-xs bg-keyboard" phx-click="keydown" phx-value-key="Enter"><%= String.upcase(value) %></kbd>
    """
  end

  defp keyboard_cell(value, keyboard_backgrounds) do
    ~E"""
    <kbd id="keyboard_cell_<%= value %>" class="kbd kbd-md sm:kbd-lg text-slate-100 cursor-default font-bold font-sans border-transparent rounded-md py-2 sm:py-3 px-0 w-2 sm:px-1 <%= keyboard_background_color(keyboard_backgrounds, value) %>"><%= String.upcase(value) %></kbd>
    """
  end

  defp keyboard_background_color(keyboard_backgrounds, value) do
    case Map.get(keyboard_backgrounds, value) do
      nil -> "bg-keyboard"
      background -> background
    end
  end

  defp input_cell_border_color(""), do: "border-gray-600"
  defp input_cell_border_color(_), do: "border-gray-500"

  def input_cell_background_color(background_colors, value, indices) do
    case Map.get(background_colors, indices) do
      nil -> "bg-transparent #{input_cell_border_color(value)} border-2"
      background_color -> "#{background_color} border-none"
    end
  end
end
