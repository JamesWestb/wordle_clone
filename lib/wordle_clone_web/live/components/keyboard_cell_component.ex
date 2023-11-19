defmodule WordleCloneWeb.KeyboardCellComponent do
  use WordleCloneWeb, :live_component

  alias WordleClone.GameUtilities
  alias WordleCloneWeb.WordView

  @impl true
  def update(%{id: id, keycap_value: keycap_value, keyboard_backgrounds: keyboard_backgrounds}, socket) do
    socket
    |> assign(:id, id)
    |> assign(:keycap_value, keycap_value)
    |> assign(:keyboard_backgrounds, keyboard_backgrounds)
    |> ok()
  end

  def render(%{keycap_value: "backspace"} = assigns) do
    ~H"""
    <kbd id={@id} class="kbd kbd-lg text-slate-100 cursor-default rounded-md border-transparent bg-keyboard" phx-click="keydown" phx-value-key="Backspace">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-10 sm:w-7">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 9.75L14.25 12m0 0l2.25 2.25M14.25 12l2.25-2.25M14.25 12L12 14.25m-2.58 4.92l-6.375-6.375a1.125 1.125 0 010-1.59L9.42 4.83c.211-.211.498-.33.796-.33H19.5a2.25 2.25 0 012.25 2.25v10.5a2.25 2.25 0 01-2.25 2.25h-9.284c-.298 0-.585-.119-.796-.33z" />
      </svg>
    </kbd>
    """
  end

  def render(%{keycap_value: "enter"} = assigns) do
    ~H"""
    <kbd id={@id} class="kbd kbd-lg text-slate-100 cursor-default font-bold border-transparent rounded-md py-3 text-xs bg-keyboard" phx-click="keydown" phx-value-key="Enter"><%= String.upcase(@keycap_value) %></kbd>
    """
  end

  def render(assigns) do
    ~H"""
    <kbd id={@id} class={"kbd kbd-md sm:kbd-lg text-slate-100 cursor-default font-bold font-sans border-transparent rounded-md py-2 sm:py-3 px-0 w-2 sm:px-1 #{WordView.keyboard_background_color(@keyboard_backgrounds, @keycap_value)}"}><%= String.upcase(@keycap_value) %></kbd>
    """
  end
end
