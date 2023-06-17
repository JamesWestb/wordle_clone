defmodule WordleCloneWeb.WordView do
  use WordleCloneWeb, :view

  def text_input_grid do
    ~E"""
    <div class="grid grid-cols-5 col-span-1 gap-2">
      <%= for _ <- 0..5 do %>
        <%= text_input_row() %>
      <% end %>
    </div>
    """
  end

  defp text_input_row do
    ~E"""
    <%= for _ <- 0..4 do %>
      <%= text_input_cell() %>
    <% end%>
    """
  end

  defp text_input_cell do
    ~E"""
    <div class="relative w-16 h-16">
      <input type="text" class="w-full h-full p-4 border-2 border-gray-500 rounded-sm outline-none focus:ring-0 focus:border-gray-500 bg-transparent" maxlength="1">
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
    <div class="w-full">
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

  defp keyboard_cell("backspace") do
    ~E"""
    <kbd class="kbd kbd-lg">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 9.75L14.25 12m0 0l2.25 2.25M14.25 12l2.25-2.25M14.25 12L12 14.25m-2.58 4.92l-6.375-6.375a1.125 1.125 0 010-1.59L9.42 4.83c.211-.211.498-.33.796-.33H19.5a2.25 2.25 0 012.25 2.25v10.5a2.25 2.25 0 01-2.25 2.25h-9.284c-.298 0-.585-.119-.796-.33z" />
      </svg>
    </kbd>
    """
  end

  defp keyboard_cell(value) do
    ~E"""
    <kbd class="kbd kbd-lg"><%= value %></kbd>
    """
  end
end
