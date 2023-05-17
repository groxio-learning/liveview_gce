defmodule Wordex.Game.Score do

  @doc """
  Given a five letter answer and a five letter guess,
  provide a score with the following rules:

  - If the correct letter is in the correct position, return {letter, :green}
  - If the correct letter is in an incorrect position, return {letter, :yellow}
  - If a letter is incorrect, return {letter, :gray}
  - A letter can only participate in a score once. That is, if a user guesses
  - two "a" letters but the answer only has one "a",
    score the correct "a" as green and the incorrect one as "gray".
  """
  def new(answer, guess) do
    answers = String.graphemes(answer)
    guesses = String.graphemes(guess)
    misses = guesses -- answers

    answers
    |> Enum.zip(guesses)
    |> Enum.map(&mark_green_or_yellow/1)
    |> mark_grays(misses)
  end

  defp mark_green_or_yellow({answer, answer}), do: {answer, :green}
  defp mark_green_or_yellow({_answer, guess}), do: {guess, :yellow}

  defp mark_grays(scores, misses) do
    mark_grays(scores, misses, [])
  end

  defp mark_grays([], _, acc), do: Enum.reverse(acc)
  defp mark_grays([{letter, color}|scores], misses, acc) do
      cond do
        (letter in misses) and (color != :green) ->
          mark_grays(
            scores,
            List.delete(misses, letter),
            [{letter, :gray}|acc])
        true ->
          mark_grays(scores, misses, [{letter, color}|acc])
      end
  end

end
