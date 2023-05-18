defmodule WordexWeb.GameLive do
  use WordexWeb, :live_view
  alias Wordex.Game
  alias WordexWeb.KeyboardKey

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

    <div class="grid grid-cols-10 gap-3 text-center font-bold">
      <%= for {letter, color} <- @result.keyboard do %>
        <KeyboardKey.key letter={letter} color={color} />
      <% end %>
    </div>

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
