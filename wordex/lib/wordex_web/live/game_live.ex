defmodule WordexWeb.GameLive do
  use WordexWeb, :live_view
  alias Wordex.Game
  alias WordexWeb.KeyboardKey

  def mount(_params, _session, socket) do
    {:ok, in_progress_game(socket)}
  end

  defp in_progress_game(socket) do
    game =
      Game.new()
      |> Game.guess("party")
      |> Game.guess("sound")

    result = Game.render(game)

    assign(socket, game: game, result: result)
  end

  def render(assigns) do
    ~H"""
    <.word_grid scores={@game.scores}/>

    <pre>
    <%= inspect @game, pretty: true %>
    </pre>

    <div class="grid grid-cols-10 gap-3 text-center font-bold">
      <%= for {letter, color} <- @result.keyboard do %>
        <KeyboardKey.key letter={letter} color={color} />
      <% end %>
    </div>
    """
  end

  attr :scores, :list
  def word_grid(assigns) do
    ~H"""
    <%= for index <- 0..5 do %>
      <.word score={@scores |> Enum.at(index)}/>
    <% end %>
    """
  end

  attr :score, :list
  def word(%{score: nil} = assigns) do
    ~H"""
    <div class="grid grid-cols-5 gap-4 text-center font-bold">
      <.word_letter letter="" color=""/>
      <.word_letter letter="" color=""/>
      <.word_letter letter="" color=""/>
      <.word_letter letter="" color=""/>
      <.word_letter letter="" color=""/>
    </div>
    """
  end

  def word(assigns) do
    ~H"""
    <div class="grid grid-cols-5 gap-4 text-center font-bold">
      <%= for {letter, color} <- @score do %>
        <.word_letter letter={letter} color={color}/>
      <% end %>
    </div>
    """
  end

  @doc """
  NOT MY PROBLEM!
  """
  attr :letter, :string
  attr :color, :atom
  def word_letter(assigns) do
    ~H"""
    <div class="border h-8 pt-2 pb-2 rounded"><%= @letter %> <%= @color %></div>
    """
  end
end
