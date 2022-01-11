defmodule PragstudioLiveviewStudioWeb.PageLive do
  @moduledoc """
  Documentation for 'PragStudioLiveViewStudioWeb.PageLive'
  """

  use PragstudioLiveviewStudioWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: "")
      |> assign(results: %{})

    {:ok, socket}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    socket =
      socket
      |> assign(query: query)
      |> assign(results: search(query))

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(query: query, results: %{})}
    end
  end

  defp search(query) do
    if not PragstudioLiveviewStudioWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
