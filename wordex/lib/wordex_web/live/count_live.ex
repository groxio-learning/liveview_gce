defmodule WordexWeb.CountLive do
  alias Wordex.Counter.IntegerCounter, as: IntegerCounter
  use WordexWeb, :live_view # calls __using__ on WordexWeb
  alias Wordex.Counter.IntegerCounter

  def mount(%{"count" => count}, _session, socket) do
    {:ok,
      socket
      |> initialize(count)
    }
  end

  defp initialize(socket, count) do
    assign(socket, count: IntegerCounter.new(count))
  end

  def render(assigns) do
    ~H"""
    <h1>Count-ARRR value: </h1>

    <.count_button event="dec" >
      <:text>
        -
      </:text>
    </.count_button>
    <%= @count %>
    <.count_button event="inc" >
      <:text>
        +
      </:text>
    </.count_button>
    <pre>
    <%= inspect assigns, pretty: true %>
    </pre>
    """
  end

  def handle_event("dec", _, socket) do
    {:noreply, socket |> dec()}
  end
  def handle_event("inc", _, socket) do
    {:noreply, socket |> inc()}
  end

  defp dec(socket) do
alias Wordex.Counter.IntegerCounter
    assign(socket, count: IntegerCounter.dec(socket.assigns.count))
  end
  defp inc(socket) do
    assign(socket, count: IntegerCounter.inc(socket.assigns.count))
  end

  attr :event, :string
  slot :text
  def count_button(assigns) do
    ~H"""
    <button
      class="btn"
      phx-click={@event}>
      <%= render_slot @text %>
    </button>
    """
  end
end
