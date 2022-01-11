defmodule PragstudioLiveviewStudioWeb.LightLive do
  @moduledoc """
  Documentation for `PragstudioLiveviewStudioWeb.LightLive`
  """

  use PragstudioLiveviewStudioWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(brightness: 10)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={["width: #{@brightness}%"]}>
         <%= @brightness %>
        </span>
      </div>


      <button phx-click="off">
        <img src="assets/images/light-off.svg" />
      </button>

      <button phx-click="down">
        <img src="assets/images/down.svg" />
      </button>

      <button phx-click="up">
        <img src="assets/images/up.svg" />
      </button>

      <button phx-click="on">
        <img src="assets/images/light-on.svg" />
      </button>
    </div>
    """
  end

  @impl true
  def handle_event("off", _, socket) do
    socket =
      socket
      |> assign(brightness: 0)

    {:noreply, socket}
  end

  @impl true
  def handle_event("on", _, socket) do
    socket =
      socket
      |> assign(brightness: 100)

    {:noreply, socket}
  end

  @impl true
  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &(&1 - 10))

    {:noreply, socket}
  end

  @impl true
  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &(&1 + 10))

    {:noreply, socket}
  end
end
