defmodule WordexWeb.SubmitGuessButton do
  alias Wordex.Game
  use Phoenix.Component

  attr :guess, :string
  def render(assigns) do
    {state, description} = Game.validate_guess(assigns.guess)
    is_disabled = case state do
      :ok -> false
      _ -> true
    end
    assigns = assign(assigns, is_disabled: is_disabled, description: description)
    ~H"""
      <h1>Current Guess</h1>
      <div><%= @guess %></div>
      <button
        phx-click="submit_guess"
        disabled={@is_disabled}
        class={["pt-2 pb-2 pl-4 pr-4 uppercase rounded", classes(@is_disabled)]}
      >
        Submit Guess
      </button>
      <span><%= @description %></span>
    """
  end

  def classes(true), do: "bg-red-500"
  def classes(false), do: "bg-green-500"
end
