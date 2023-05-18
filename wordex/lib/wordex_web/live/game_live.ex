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
end
