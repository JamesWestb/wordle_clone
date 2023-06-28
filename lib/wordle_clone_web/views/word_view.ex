defmodule WordleCloneWeb.WordView do
  use WordleCloneWeb, :view
  alias WordleClone.GameUtilities

  def text_input_grid(changeset) do
    ~E"""
    <div class="grid grid-cols-1 self-end mb-5 gap-y-2">
      <div class="grid grid-cols-1 col-span-1 gap-2">
        <%= for row_index <- 0..5 do %>
          <%= text_input_row(row_index, changeset) %>
        <% end %>
      </div>
    </div>
    """
  end

  defp text_input_row(row_index, changeset) do
    ~E"""
    <div id="row_<%= row_index %>" class="col-span-1 grid grid-cols-5 gap-2 flex justify-items-center">
      <%= for column_index <- 0..4 do %>
        <%= text_input_cell(row_index, column_index, changeset) %>
      <% end%>
    </div>
    """
  end

  defp text_input_cell(row_index, column_index, changeset) do
    cell_indices = "#{row_index}-#{column_index}"

    ~E"""
    <div class="relative w-16 h-16 col-span-1 pointer-events-none">
      <input id="input_cell_<%= cell_indices %>" type="text" value="<%= GameUtilities.find_input_cell_value(cell_indices, changeset) %>" class="w-full h-full p-4 border-2 border-gray-500 rounded-sm text-3xl text-center font-bold outline-none focus:ring-0 focus:border-gray-500 cursor-default bg-transparent" maxlength="1">
    </div>
    """
  end

  def keyboard do
    keyboard_rows = [
      ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
      ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
      ["enter", "z", "x", "c", "v", "b", "n", "m", "backspace"]
    ]

    ~E"""
    <div class="w-full h-1/3">
      <%= for keyboard_row <- keyboard_rows do %>
        <div class="flex justify-center gap-1 my-1 w-full">
          <%= for value <- keyboard_row do %>
            <%= keyboard_cell(value) %>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  defp keyboard_cell(value) when value == "backspace" do
    ~E"""
    <kbd id="value" class="kbd kbd-lg cursor-pointer rounded-md">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 9.75L14.25 12m0 0l2.25 2.25M14.25 12l2.25-2.25M14.25 12L12 14.25m-2.58 4.92l-6.375-6.375a1.125 1.125 0 010-1.59L9.42 4.83c.211-.211.498-.33.796-.33H19.5a2.25 2.25 0 012.25 2.25v10.5a2.25 2.25 0 01-2.25 2.25h-9.284c-.298 0-.585-.119-.796-.33z" />
      </svg>
    </kbd>
    """
  end

  defp keyboard_cell(value) when value == "enter" do
    ~E"""
    <kbd id="<%= value %>" class="kbd kbd-lg cursor-pointer font-bold rounded-md py-3 text-xs"><%= String.upcase(value) %></kbd>
    """
  end

  defp keyboard_cell(value) do
    ~E"""
    <kbd id="<%= value %>" class="kbd kbd-lg cursor-pointer font-bold rounded-md py-3 px-1"><%= String.upcase(value) %></kbd>
    """
  end
end
