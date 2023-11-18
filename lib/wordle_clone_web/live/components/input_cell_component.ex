defmodule WordleCloneWeb.InputCellComponent do
  use WordleCloneWeb, :live_component

  alias WordleClone.GameUtilities

  @impl true
  def update(
        %{
          id: id,
          input_cell_backgrounds: input_cell_backgrounds,
          cell_indices: cell_indices,
          changeset: changeset
        },
        socket
      ) do
    socket
    |> assign(:id, id)
    |> assign(:input_cell_backgrounds, input_cell_backgrounds)
    |> assign(:cell_indices, cell_indices)
    |> assign(:changeset, changeset)
    |> ok()
  end

  @impl true
  def render(%{cell_indices: cell_indices, changeset: changeset} = assigns) do
    input_value = GameUtilities.find_input_cell_value(cell_indices, changeset)

    ~H"""
    <div class="relative sm:w-16 sm:h-16 h-14 w-14 col-span-1 pointer-events-none select-none">
      <input
        id={@id}
        type="text"
        value={input_value}
        class={"w-full h-full p-3 #{WordleCloneWeb.WordView.input_cell_background_color(@input_cell_backgrounds, input_value, @cell_indices)} text-slate-100 rounded-sm text-3xl text-center font-bold cursor-default"}
        maxlength="1"
      />
    </div>
    """
  end
end
