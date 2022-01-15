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
      |> assign(temp: 3000)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background-color: #{temp_color(@temp)}"}>
         <%= @brightness %>
        </span>
      </div>

      <form phx-change="update">
        <input type="range" min="0" max="100" name="brightness" value={@brightness}/>
      </form>

      <form phx-change="change-temp">

        <input type="radio" id="3000" name="temp" value="3000" checked={@temp == 3000} />
        <label for="3000">3000</label>

        <input type="radio" id="4000" name="temp" value="4000" checked={@temp == 4000} />
        <label for="4000">4000</label>

        <input type="radio" id="5000" name="temp" value="5000" checked={@temp == 5000} />
        <label for="5000">5000</label>

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

  @impl true
  def handle_event("change-temp", %{"temp" => temp}, socket) do
    socket =
      socket
      |> assign(temp: temp |> String.to_integer())

    {:noreply, socket}
  end

  defp temp_color(3000), do: "#F1C40D"

  defp temp_color(4000), do: "#FEFF66"

  defp temp_color(5000), do: "#99CCFF"
end
