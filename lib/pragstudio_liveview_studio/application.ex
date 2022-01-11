defmodule PragstudioLiveviewStudio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PragstudioLiveviewStudio.Repo,
      # Start the Telemetry supervisor
      PragstudioLiveviewStudioWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PragstudioLiveviewStudio.PubSub},
      # Start the Endpoint (http/https)
      PragstudioLiveviewStudioWeb.Endpoint
      # Start a worker by calling: PragstudioLiveviewStudio.Worker.start_link(arg)
      # {PragstudioLiveviewStudio.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PragstudioLiveviewStudio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PragstudioLiveviewStudioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
