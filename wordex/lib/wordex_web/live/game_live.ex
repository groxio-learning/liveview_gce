defmodule WordexWeb.GameLive do
  use WordexWeb, :live_view
  alias Wordex.Game
  alias WordexWeb.KeyboardKey
  alias WordexWeb.SubmitGuessButton

  def mount(_params, _session, socket) do
    {:ok, socket |> in_progress_game() |> assign(:guess, "")}
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
    <h1>Wordex With Buttons</h1>
    <.word_grid scores={@game.scores} />
    <%= @guess %>

    <div class="grid grid-cols-10 gap-3 font-bold text-center">
      <%= for {letter, color} <- @result.keyboard do %>
        <KeyboardKey.key letter={letter} color={color} />
      <% end %>
    </div>
    <SubmitGuessButton.render guess={@guess} />
    """
  end

  def handle_event("add_letter", %{"letter" => letter}, socket) do
    guess = add_letter(socket.assigns.guess, letter)
    {:noreply, assign(socket, guess: guess)}
  end

  def add_letter(guess, letter) do
    case String.length(guess) do
      5 -> guess
      _ -> guess <> letter
    end
  end

  attr :scores, :list

  def word_grid(assigns) do
    ~H"""
    <%= for index <- 0..5 do %>
      <.word score={@scores |> Enum.at(index)} />
    <% end %>
    """
  end

  attr :score, :list

  def word(%{score: nil} = assigns) do
    ~H"""
    <div class="grid grid-cols-5 gap-4 font-bold text-center">
      <.word_letter letter="" color="" />
      <.word_letter letter="" color="" />
      <.word_letter letter="" color="" />
      <.word_letter letter="" color="" />
      <.word_letter letter="" color="" />
    </div>
    """
  end

  def word(assigns) do
    ~H"""
    <div class="grid grid-cols-5 gap-4 font-bold text-center">
      <%= for {letter, color} <- @score do %>
        <.word_letter letter={String.upcase(letter)} color={color} />
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
    <div class={"#{bg_color(@color)} text-white pt-2 pb-2 mb-4 rounded"}><%= @letter %></div>
    """
  end

  defp bg_color(:green), do: "bg-green-600"
  defp bg_color(:yellow), do: "bg-yellow-500"
  defp bg_color(:gray), do: "bg-gray-500"
  defp bg_color(_), do: ""

  defp keyboard(assigns) do
    ~H"""
    <div class="grid grid-cols-10 gap-3 font-bold text-center">
      <%= for i <- keyboard_rows() do %>
        <.keyboard_row letters={i} />
      <% end %>
    </div>
    """
  end

  def handle_event("submit_guess", _metadata, socket) do
    {:no_reply, submit_guess(socket)}
  end

  defp submit_guess(socket) do
    new_guess = socket.guess

    game =
      socket.game
      |> Game.guess(new_guess)

    result = Game.render(game)

    assign(socket, game: game, result: result)
  end


  attr :letters, :list

  defp keyboard_row(assigns) do
    ~H"""
    <%= for i <- @letters do %>
      <%= if i == "-" do %>
        <div />
      <% else %>
        <.keyboard_letter letter={i} />
      <% end %>
    <% end %>
    """
  end

  attr :letter, :string

  defp keyboard_letter(assigns) do
    ~H"""
      <button
        class="pt-2 pb-2 text-white bg-green-600 rounded"
        phx-click="guess"
        phx-value-letter={@letter}>
        <%= @letter %>
      </button>
    """
  end

  defp keyboard_rows() do
    [
      ~w(q w e r t y u i o p),
      ~w(a s d f g h j k l -),
      ~w(- z x c v b n m - -)
    ]
  end
end
