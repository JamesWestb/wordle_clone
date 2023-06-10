defmodule WordleClone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      WordleClone.Repo,
      # Start the Telemetry supervisor
      WordleCloneWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: WordleClone.PubSub},
      # Start the Endpoint (http/https)
      WordleCloneWeb.Endpoint
      # Start a worker by calling: WordleClone.Worker.start_link(arg)
      # {WordleClone.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WordleClone.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WordleCloneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
