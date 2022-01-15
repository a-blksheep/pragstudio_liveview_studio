defmodule PragstudioLiveviewStudioWeb.LicenseLive do
  @moduledoc """
  Documentation for `PragstudioLiveviewStudioWeb.LicenseLive`.
  """

  use PragstudioLiveviewStudioWeb, :live_view

  alias PragstudioLiveviewStudio.Licenses
  import Number.Currency

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    expiration_time = Timex.shift(Timex.now(), hours: 1)
    time_remaining = time_remaining(expiration_time)

    socket =
      socket
      |> assign(amount: Licenses.calculate(2))
      |> assign(expiration_time: expiration_time)
      |> assign(seats: 2)
      |> assign(time_remaining: time_remaining)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Team License</h1>
    <div id="license">
      <p class="m-4 font-semibold text-indigo-800">
        <%= if @time_remaining > 0 do %>
          <%= format_time(@time_remaining) %> left to save 20%
        <% else %>
          Expired!
        <% end %>
      </p>
      <div class="card">
        <div class="content">
          <div class="seats">
            <img src="assets/images/license.svg">
            <span>
              Your license is currently for
              <strong><%= @seats %></strong> <%= ngettext("seat", "seats", @seats) %>.
            </span>
          </div>
          <form phx-change="update">
            <input type="range" min="1" max="10" name="seats" value={ @seats } phx-debounce="250" />
          </form>
          <div class="amount">
            <%= number_to_currency(@amount) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("update", %{"seats" => seats}, socket) do
    seats = String.to_integer(seats)

    socket =
      socket
      |> assign(amount: Licenses.calculate(seats))
      |> assign(seats: seats)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    time_remaining =
      socket.assigns.expiration_time
      |> time_remaining()

    socket =
      socket
      |> assign(time_remaining: time_remaining)

    {:noreply, socket}
  end

  defp time_remaining(expiration_time) do
    DateTime.diff(expiration_time, Timex.now())
  end

  defp format_time(time) do
    time
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end
end
