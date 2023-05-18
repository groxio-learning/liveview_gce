defmodule WordexWeb.ExampleLive do
  use WordexWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("click", _metadata, socket) do
    {:noreply, socket}
  end
end
