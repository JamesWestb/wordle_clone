defmodule WordleCloneWeb.WordView do
  use WordleCloneWeb, :view
  alias WordleClone.GameUtilities

  def text_input_grid(input_cell_backgrounds, changeset) do
    ~E"""
    <div id="text_input_grid" phx-hook="characterInputAnimation" class="grid grid-cols-1 self-start mt-5 mb-5 gap-y-1">
      <div class="grid grid-cols-1 col-span-1 gap-1.5">
        <%= for row_index <- 0..5 do %>
          <%= text_input_row(input_cell_backgrounds, row_index, changeset) %>
        <% end %>
      </div>
    </div>
    """
  end

  defp text_input_row(input_cell_backgrounds, row_index, changeset) do
    ~E"""
    <div id="row_<%= row_index %>" class="col-span-1 grid grid-cols-5 gap-1.5 flex justify-items-center">
      <%= for column_index <- 0..4 do %>
        <%= text_input_cell(input_cell_backgrounds, row_index, column_index, changeset) %>
      <% end%>
    </div>
    """
  end

  defp text_input_cell(input_cell_backgrounds, row_index, column_index, changeset) do
    cell_indices = GameUtilities.stringify_cell_indices(row_index, column_index)
    input_value = GameUtilities.find_input_cell_value(cell_indices, changeset)

    ~E"""
    <div class="relative sm:w-16 sm:h-16 h-14 w-14 col-span-1 pointer-events-none select-none">
      <input id="input_cell_<%= cell_indices %>" type="text" value="<%= input_value %>" class="w-full h-full p-3 <%= input_cell_background_color(input_cell_backgrounds, input_value, cell_indices) %> text-slate-100 rounded-sm text-3xl text-center font-bold cursor-default" maxlength="1">
    </div>
    """
  end

  def keyboard(keyboard_backgrounds) do
    keyboard_rows = [
      ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
      ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
      ["enter", "z", "x", "c", "v", "b", "n", "m", "backspace"]
    ]

    ~E"""
    <div class="w-full h-full">
      <%= for keyboard_row <- keyboard_rows do %>
        <div class="flex justify-center gap-1 mb-1.5 sm:w-full sm:h-full h-14">
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
    <kbd id="value" class="kbd kbd-lg text-slate-100 cursor-default rounded-md border-transparent bg-keyboard" phx-click="keydown" phx-value-key="Backspace">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-7">
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
    <kbd id="keyboard_cell_<%= value %>" phx-throttle="0" class="kbd kbd-md sm:kbd-lg text-slate-100 cursor-default font-bold font-sans border-transparent rounded-md py-2 sm:py-3 px-0 sm:px-1 <%= keyboard_background_color(keyboard_backgrounds, value) %>"><%= String.upcase(value) %></kbd>
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

  defp input_cell_background_color(background_colors, value, indices) do
    case Map.get(background_colors, indices) do
      nil -> "bg-transparent #{input_cell_border_color(value)} border-2"
      background_color -> "#{background_color} border-none"
    end
  end
end
