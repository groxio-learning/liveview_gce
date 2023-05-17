defmodule Wordex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WordexWeb.Telemetry,
      # Start the Ecto repository
      Wordex.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Wordex.PubSub},
      # Start Finch
      {Finch, name: Wordex.Finch},
      # Start the Endpoint (http/https)
      WordexWeb.Endpoint
      # Start a worker by calling: Wordex.Worker.start_link(arg)
      # {Wordex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wordex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WordexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
