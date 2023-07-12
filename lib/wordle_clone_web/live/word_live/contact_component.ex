defmodule WordleCloneWeb.WordLive.ContactComponent do
  use WordleCloneWeb, :live_component

  @impl true
  def update(%{title: title, email_copied: email_copied}, socket) do
    socket
    |> assign(:title, title)
    |> assign(:email_copied, email_copied)
    |> assign(:contact_email, Application.get_env(:wordle_clone, :contact_email))
    |> ok()
  end

  @impl true
  def handle_event("copy-email", _, %{assigns: %{title: title}} = socket) do
    send_update_after(__MODULE__, [id: :contact, email_copied: false, title: title], 750)

    socket
    |> assign(email_copied: true)
    |> noreply()
  end

  def handle_event("revert_copy_icon", _, socket) do
    socket
    |> assign(email_copied: false)
    |> noreply()
  end
end
