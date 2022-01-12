defmodule PragstudioLiveviewStudioWeb.SalesDashboardLive do
  @moduledoc """
  Documentation for `PragstudioLiveviewStudioWeb.SalesDashboardLive`.
  """

  use PragstudioLiveviewStudioWeb, :live_view

  alias PragstudioLiveviewStudio.Sales

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_stats()
      |> assign(refresh: 1)
      |> assign(last_updated_at: Timex.now())

    if connected?(socket), do: schedule_refresh(socket)

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
      <div class="controls">
        <form phx-change="select-refresh">
          <label for="refresh">
            Refresh every:
          </label>
          <select name="refresh">
            <%= options_for_select(refresh_options(), @refresh) %>
          </select>
        </form>

        <button phx-click="refresh">
          <img src="assets/images/refresh.svg">
          Refresh
        </button>
        <span class="m-4 font-light text-indigo-800">
          <strong class="text-semibold">Last updated</strong>: <%= Timex.format!(@last_updated_at, "%H:%M:%S", :strftime) %>
        </span>
      </div>
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
  def handle_event("select-refresh", %{"refresh" => refresh}, socket) do
    refresh =
      refresh
      |> String.to_integer()

    socket =
      socket
      |> assign(refresh: refresh)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    socket =
      socket
      |> assign_stats()
      |> assign(last_updated_at: Timex.now())

    schedule_refresh(socket)

    {:noreply, socket}
  end

  defp assign_stats(socket) do
    socket
    |> assign(new_orders: Sales.new_orders())
    |> assign(sales_amount: Sales.sales_amount())
    |> assign(satisfaction: Sales.satisfaction())
  end

  defp refresh_options do
    [{"1s", 1}, {"5s", 5}, {"15s", 15}, {"30s", 30}, {"60s", 60}]
  end

  defp schedule_refresh(socket) do
    Process.send_after(self(), :tick, socket.assigns.refresh * 1000)
  end
end
