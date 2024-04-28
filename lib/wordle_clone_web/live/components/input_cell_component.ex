defmodule WordleCloneWeb.InputCellComponent do
  use WordleCloneWeb, :live_component

  alias WordleClone.GameUtilities
  alias WordleCloneWeb.WordView

  @impl true
  def update(
        %{
          id: id,
          input_cell_backgrounds: input_cell_backgrounds,
          changeset: changeset
        },
        socket
      ) do
    socket
    |> assign(:id, id)
    |> assign(:input_cell_backgrounds, input_cell_backgrounds)
    |> assign(:changeset, changeset)
    |> ok()
  end

  @impl true
  def render(%{id: id, changeset: changeset} = assigns) do
    input_value = GameUtilities.find_input_cell_value(id, changeset)

    ~H"""
    <input
      id={@id}
      type="text"
      value={input_value}
      class={"#{WordView.input_cell_background_color(@input_cell_backgrounds, input_value, @id)} relative sm:w-16 w-14 sm:h-16 h-14 col-span-1 pointer-events-none select-none p-3 text-slate-100 rounded-sm text-3xl text-center font-bold cursor-default"}
      maxlength="1"
    />
    """
  end
end
