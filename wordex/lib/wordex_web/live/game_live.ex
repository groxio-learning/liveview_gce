defmodule WordexWeb.GameLive do
  use WordexWeb, :live_view
  alias Wordex.Game

  def mount(_params, _session, socket) do
    {:ok, in_progress_game(socket)}
  end

  def render(assigns) do
    ~H"""
    hello, world

    <pre>
      <%= inspect @game, pretty: true %>
    </pre>
    <br/>
    <br/>
    <hr/>
    <br/>
    <br/>
    <pre>
      <%= inspect @result, pretty: true %>
    </pre>

    """
  end

  defp in_progress_game(socket) do
    game =
      Game.new()
      |> Game.guess("party")
      |> Game.guess("sound")

    result = Game.render(game)

    assign(socket, game: game, result: result)
  end

  attr :letter, :string
  attr :color, :atom
  def word_letter(assigns) do
    ~H"""
    <div class={"#{bg_styling(@color, @letter)}"}><%= @letter %></div>
    """
  end

  defp bg_styling(:green, _), do: "bg-green-600 text-white pt-2 pb-2 rounded"
  defp bg_styling(:yellow, _), do: "bg-yellow-500 text-white pt-2 pb-2 rounded"
  defp bg_styling(:gray, _), do: "bg-gray-500 text-white pt-2 pb-2 rounded"
  defp bg_styling(:white, ""), do: "bg-white-500 border text-black pt-2 pb-2 rounded"
  defp bg_styling(:white, nil), do: "bg-white-500 border text-black pt-2 pb-2 rounded"
  defp bg_styling(:white, _), do: "bg-white-500 border-black border-2 text-black pt-2 pb-2 rounded"
end
