defmodule PragstudioLiveviewStudioWeb.SearchLive do
  @moduledoc """
  Documentation for `PragstudioLiveviewStudioWeb.SearchLive`.
  """

  use PragstudioLiveviewStudioWeb, :live_view

  alias PragstudioLiveviewStudio.Stores

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(zip: "")
      |> assign(stores: [])
      |> assign(loading: false)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Find a Store</h1>
    <div id="search">
      <form phx-submit="zip-search">

        <input type="text" name="zip"
        value={@zip} placeholder="Zip code"
        autofocus autocomplete="off"
        readonly={@loading} />

        <button type="submit">
          <img src="assets/images/search.svg" />
        </button>

      </form>

      <%= if @loading do %>
      <div class="loader">
        Loading...
      </div>
      <% end %>
    </div>
    <div id="search">
        <div class="stores">
            <ul>
            <%= for store <- @stores do %>
                <li>
                    <div class="first-line">
                        <div class="name">
                            <%= store.name %>
                        </div>
                        <div class="status">
                        <%= if store.open do %>
                            <span class="open">Open</span>
                        <% else %>
                            <span class="closed">Closed</span>
                        <% end %>
                        </div>
                    </div>
                    <div class="second-line">
                        <div class="street">
                            <img src="assets/images/location.svg">
                            <%= store.street %>
                        </div>
                        <div class="phone_number">
                            <img src="assets/images/phone.svg">
                            <%= store.phone_number %>
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
  def handle_event("zip-search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})

    socket =
      socket
      |> assign(stores: [])
      |> assign(loading: true)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:run_zip_search, zip}, socket) do
    case Stores.search_by_zip(zip) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No stores matching specified zip")
          |> assign(stores: [])
          |> assign(loading: false)

        {:noreply, socket}

      stores ->
        socket =
          socket
          |> clear_flash()
          |> assign(stores: stores)
          |> assign(loading: false)

        {:noreply, socket}
    end
  end
end
