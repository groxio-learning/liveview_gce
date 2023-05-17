defmodule Wordex.Game do
  alias Wordex.Game.Core
  alias Wordex.Words
  def new() do
    Words.random()
    |> Core.new()
  end

  @doc """
  TODO: Validation will go here!
  """
  def guess(game, guess) do
    Core.guess(game, guess)
  end

  def render(game) do
    Core.show(game)
  end

  def validate_guess(guess) do
    cond do
      Words.member?(guess) -> {:ok, guess}
      true -> {:error, "Guess must be in dictionary"}
    end
  end
end
