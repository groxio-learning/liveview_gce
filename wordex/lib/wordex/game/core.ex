defmodule Wordex.Game.Core do
  defstruct scores: [], status: :playing, answer: "guess"

  alias Wordex.Game.Score

  @doc """
  Our constructor.
  Build a Wordle game core. Track the answer, guesses, and status.
  """
  def new(answer \\ "guess") do
    %__MODULE__{answer: answer}
  end

  @doc """
  Our reducer.
  Adds a scored guess to a game, and returns the current status.
  """
  def guess(game, guess) do
    score = Score.new(game.answer, guess)

    %{game| scores: [score|game.scores]}
    |> status(guess)
  end

  @doc """
  Compute the status of a game, an atom from won/lost/playing.
  """
  def status(game, guess) do
    new_status =
      cond do
        game.answer == guess -> :won
        length(game.scores) == 6 -> :lost
        true -> :playing
      end
    %{game | status: new_status}
  end

  @doc """
  Provide the details needed to render the current game state.
  Provides the grid of scores, the letters of a keyboard, the
  colors of each, and the status.
  """
  def show(game) do
    %{scores: game.scores, status: game.status, keyboard: keyboard_letters(game)}
  end

  defp keyboard_letters(game) do
    all_letters = for c <- ?a..?z, into: %{}, do: {<<c>>, :white}

    game.scores
    |> List.flatten
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(fn {key, guess_colors} -> {key, keyboard_color(guess_colors)} end)
    |> Enum.into(all_letters)
  end

  defp keyboard_color(guess_colors) do
    [:green, :yellow, :gray]
    |> Enum.drop_while(fn color -> color not in guess_colors end)
    |> List.first()
    |> Kernel.||(:white)
  end
end
