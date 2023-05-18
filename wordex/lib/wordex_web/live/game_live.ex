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
    <div class={"#{bg_color(@color)} text-white pt-2 pb-2 rounded"}><%= @letter %></div>
    """
  end

  defp bg_color(:green), do: "bg-green-600"
  defp bg_color(:yellow), do: "bg-yellow-500"
  defp bg_color(:gray), do: "bg-gray-500"
end
