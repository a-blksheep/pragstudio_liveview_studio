defmodule PragstudioLiveviewStudioWeb.LicenseLive do
  @moduledoc """
  Documentation for `PragstudioLiveviewStudioWeb.LicenseLive`.
  """

  use PragstudioLiveviewStudioWeb, :live_view

  alias PragstudioLiveviewStudio.Licenses
  import Number.Currency

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(amount: Licenses.calculate(2))
      |> assign(seats: 2)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Team License</h1>
    <div id="license">
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
            <input type="range" min="1" max="10" name="seats" value={ @seats } />
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
end
