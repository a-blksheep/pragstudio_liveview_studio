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

      <form phx-change="update">
        <input type="range" min="0" max="100" name="brightness" value={@brightness}/>
      </form>
    </div>
    """
  end

  @impl true
  def handle_event("update", %{"brightness" => brightness}, socket) do
    brightness =
      brightness
      |> String.to_integer()

    socket = socket |> assign(brightness: brightness)

    {:noreply, socket}
  end
end
