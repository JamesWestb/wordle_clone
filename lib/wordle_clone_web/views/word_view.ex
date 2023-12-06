defmodule WordleCloneWeb.WordView do
  use WordleCloneWeb, :view

  def keyboard_background_color(keyboard_backgrounds, value) do
    case Map.get(keyboard_backgrounds, value) do
      nil -> "bg-keyboard"
      background -> background
    end
  end

  defp input_cell_border_color(""), do: "border-gray-600"
  defp input_cell_border_color(_), do: "border-gray-500"

  def input_cell_background_color(background_colors, value, indices) do
    case Map.get(background_colors, "input_cell_#{indices}") do
      nil -> "bg-transparent #{input_cell_border_color(value)} border-2"
      background_color -> "#{background_color} border-none"
    end
  end
end
