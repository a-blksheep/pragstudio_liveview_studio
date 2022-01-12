defmodule PragstudioLiveviewStudioWeb.SalesDashboardLive do
  @moduledoc """
  Documentation for `PragstudioLiveviewStudioWeb.SalesDashboardLive`.
  """

  use PragstudioLiveviewStudioWeb, :live_view

  alias PragstudioLiveviewStudio.Sales

  @impl true
  def mount(_params, _session, socket) do
    # We want to start sending a message to
    # ourself every second, however `mount/3`
    # is called twice. So we want to wait
    # until we are in a connected state.
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    socket =
      socket
      |> assign_stats()

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Sales Dashboard</h1>
    <div id="dashboard">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="name">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="name">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="name">
            Satisfaction
          </span>
        </div>
      </div>
      <button phx-click="refresh">
        <img src="assets/images/refresh.svg">
        Refresh
      </button>
    </div>
    """
  end

  @impl true
  def handle_event("refresh", _params, socket) do
    socket =
      socket
      |> assign_stats()

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    socket =
      socket
      |> assign_stats()

    {:noreply, socket}
  end

  defp assign_stats(socket) do
    socket
    |> assign(new_orders: Sales.new_orders())
    |> assign(sales_amount: Sales.sales_amount())
    |> assign(satisfaction: Sales.satisfaction())
  end
end
