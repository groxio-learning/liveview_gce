defmodule Wordex.Words do
  @filename "./priv/words.txt"
  @word_list (@filename |> File.read!() |> String.split("\n"))
  @word_mapset MapSet.new(@word_list)

  def random(), do: Enum.random(@word_list)
  def member?(word), do: MapSet.member?(@word_mapset, word)
end
