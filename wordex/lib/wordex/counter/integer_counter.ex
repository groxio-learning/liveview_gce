defmodule Wordex.Counter.IntegerCounter do
  def new(input \\ "0") do
    String.to_integer(input)
  end

  def inc(acc) do
    acc + 1
  end

  def dec(acc) do
    acc - 1
  end

  def show(acc) do
    "The count-ARRR is #{acc}"
  end
end
