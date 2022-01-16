defmodule PragstudioLiveviewStudioWeb.FlightsLive do
  @moduledoc """
  Documentation for `PragstudioLiveviewStudioWeb.FlightsLive`.
  """

  use PragstudioLiveviewStudioWeb, :live_view

  alias PragstudioLiveviewStudio.Airports
  alias PragstudioLiveviewStudio.Flights

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(airport: "")
      |> assign(flight_number: "")
      |> assign(flights: [])
      |> assign(matches: [])
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

        <form phx-submit="airport-search" phx-change="suggest-airport">

            <input type="text" name="airport"
            value={@airport} placeholder="Enter airport.."
            autocomplete="off"
            readonly={@loading}
            debounce="1000"
            list="matches" />

            <button type="submit">
            <img src="assets/images/search.svg" />
            </button>

        </form>

        <datalist id="matches">
        <%= for match <- @matches do %>
          <option value={match}><%= match %></option>
        <% end %>
        </datalist>

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
  def handle_event("suggest-airport", %{"airport" => prefix}, socket) do
    socket =
      socket
      |> assign(matches: Airports.suggest(prefix))

    {:noreply, socket}
  end

  @impl true
  def handle_event("airport-search", %{"airport" => airport}, socket) do
    send(self(), {:run_airport_search, airport})

    socket =
      socket
      |> assign(airports: [])
      |> assign(loading: true)

    {:noreply, socket}
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
  def handle_info({:run_airport_search, airport}, socket) do
    airport |> IO.inspect()

    case Flights.search_by_airport(airport) do
      [] ->
        socket =
          socket
          |> put_flash(
            :info,
            "No matching flights found. Please enter a different airport code."
          )
          |> assign(flights: [])
          |> assign(loading: false)

        {:noreply, socket}

      airports ->
        socket =
          socket
          |> clear_flash()
          |> assign(flights: airports)
          |> assign(loading: false)

        {:noreply, socket}
    end
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
