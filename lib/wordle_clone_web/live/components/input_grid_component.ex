defmodule WordleCloneWeb.InputGridComponent do
  use WordleCloneWeb, :live_component

  @impl true
  def update(
        %{id: id, input_cell_backgrounds: input_cell_backgrounds, changeset: changeset},
        socket
      ) do
    socket
    |> assign(:id, id)
    |> assign(:input_cell_backgrounds, input_cell_backgrounds)
    |> assign(:changeset, changeset)
    |> ok()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="characterInputAnimation"
      phx-target="myself"
      class="grid grid-cols-1 self-start mt-5 mb-5 gap-y-1"
    >
      <div class="grid grid-cols-1 col-span-1 gap-1.5">
        <%= for row_index <- 0..5 do %>
          <.live_component
            module={WordleCloneWeb.InputRowComponent}
            id={"input_row_#{row_index}"}
            input_cell_backgrounds={@input_cell_backgrounds}
            row_index={row_index}
            changeset={@changeset}
          />
        <% end %>
      </div>
    </div>
    """
  end
end
