defmodule Kotkowo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application

  alias Kotkowo.AdviceHandler
  alias Kotkowo.Plausible.ViewPuller

  @impl true
  def start(_type, _args) do
    children =
      Enum.filter(
        [
          KotkowoWeb.Telemetry,
          {Phoenix.PubSub, name: Kotkowo.PubSub},
          KotkowoWeb.Endpoint,
          Kotkowo.PromEx,
          maybe_view_puller(),
          maybe_advice_handler()
        ],
        & &1
      )

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

  defp maybe_advice_handler do
    if Application.get_env(:kotkowo, :enable_advice_handler, false) do
      Supervisor.child_spec({AdviceHandler, nil}, id: AdviceHandler, restart: :permanent)
    end
  end

  defp maybe_view_puller do
    if Application.get_env(:kotkowo, :enable_view_puller, false) do
      Supervisor.child_spec({ViewPuller, [interval: 5 * 60 * 1000]}, id: ViewPuller, restart: :permanent)
    end
  end
end
