defmodule WordleCloneWeb.InputRowComponent do
  use WordleCloneWeb, :live_component

  alias WordleClone.GameUtilities

  @impl true
  def update(
        %{
          id: id,
          input_cell_backgrounds: input_cell_backgrounds,
          row_index: row_index,
          changeset: changeset
        },
        socket
      ) do
    socket
    |> assign(:id, id)
    |> assign(:input_cell_backgrounds, input_cell_backgrounds)
    |> assign(:row_index, row_index)
    |> assign(:changeset, changeset)
    |> ok()
  end

  def render(assigns) do
    ~H"""
    <div
      id={@id}
      phx-target="myself"
      class="col-span-1 gap-1.5 flex justify-items-center justify-center"
    >
      <%= for column_index <- 0..4 do %>
        <.live_component
          module={WordleCloneWeb.InputCellComponent}
          id={"input_cell_#{stringify_cell_indices(@row_index, column_index)}"}
          input_cell_backgrounds={@input_cell_backgrounds}
          cell_indices={stringify_cell_indices(@row_index, column_index)}
          changeset={@changeset}
        />
      <% end %>
    </div>
    """
  end

  defp stringify_cell_indices(row_index, column_index),
    do: GameUtilities.stringify_cell_indices(row_index, column_index)
end
