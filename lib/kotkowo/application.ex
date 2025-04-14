defmodule Kotkowo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application

  alias Kotkowo.AdviceHandler
  alias Kotkowo.Plausible.ViewPuller

  @impl true
  def start(_type, _args) do
    internal_services = Application.get_env(:kotkowo, :services, Keyword.new())

    children =
      [
        KotkowoWeb.Telemetry,
        {Phoenix.PubSub, name: Kotkowo.PubSub},
        KotkowoWeb.Endpoint,
        Kotkowo.PromEx,
        Supervisor.child_spec({AdviceHandler, nil}, id: AdviceHandler, restart: :permanent)
      ] ++ maybe_view_puller(internal_services)

    # Start the Telemetry supervisor

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kotkowo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KotkowoWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp maybe_view_puller(services) do
    if services[:enable_view_puller] do
      [Supervisor.child_spec({ViewPuller, [interval: 5 * 60 * 1000]}, id: ViewPuller, restart: :permanent)]
    else
      []
    end
  end
end
