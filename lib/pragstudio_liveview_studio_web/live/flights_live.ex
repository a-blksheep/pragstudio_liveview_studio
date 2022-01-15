defmodule PragstudioLiveviewStudioWeb.FlightsLive do
  @moduledoc """
  Documentation for `PragstudioLiveviewStudioWeb.FlightsLive`.
  """

  use PragstudioLiveviewStudioWeb, :live_view

  alias PragstudioLiveviewStudio.Flights

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(flight_number: "")
      |> assign(flights: [])
      |> assign(loading: false)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Find a Flight</h1>
    <div id="search">

        <form phx-submit="flight-search">

            <input type="text" name="flight-number"
            value={@flight_number} placeholder="Enter flight number.."
            autofocus autocomplete="off"
            readonly={@loading} />

            <button type="submit">
            <img src="assets/images/search.svg" />
            </button>

        </form>

        <%= if @loading do %>
        <div class="loader">Loading...</div>
        <% end %>

        <div class="flights">
        <ul>
            <%= for flight <- @flights do %>
            <li>
                <div class="first-line">
                <div class="number">
                    Flight #<%= flight.number %>
                </div>
                <div class="origin-destination">
                    <img src="assets/images/location.svg">
                    <%= flight.origin %> to
                    <%= flight.destination %>
                </div>
                </div>
                <div class="second-line">
                <div class="departs">
                    Departs: <%= flight.departure_time |> format_datetime() %>
                </div>
                <div class="arrives">
                    Arrives: <%= flight.arrival_time |> format_datetime() %>
                </div>
                </div>
            </li>
            <% end %>
        </ul>
        </div>
    </div>
    """
  end

  @impl true
  def handle_event("flight-search", %{"flight-number" => flight_number}, socket) do
    send(self(), {:run_flight_search, flight_number})

    socket =
      socket
      |> assign(flights: [])
      |> assign(loading: true)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:run_flight_search, flight_number}, socket) do
    case Flights.search_by_number(flight_number) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No matching flights found. Please enter a different flight number")
          |> assign(flights: [])
          |> assign(loading: false)

        {:noreply, socket}

      flights ->
        socket =
          socket
          |> clear_flash()
          |> assign(flights: flights)
          |> assign(loading: false)

        {:noreply, socket}
    end
  end

  defp format_datetime(datetime) do
    case Timex.format(datetime, "%Y-%m-%d %H:%M:%S", :strftime) do
      {:ok, datetime} ->
        datetime

      {:error, reason} ->
        IO.inspect(reason)
        datetime
    end
  end
end
