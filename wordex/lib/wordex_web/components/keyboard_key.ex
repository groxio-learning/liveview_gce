defmodule WordexWeb.KeyboardKey do
  use Phoenix.Component

  attr :letter, :string
  attr :color, :atom

  def key(assigns) do
    ~H"""
    <div
      phx-click="add_letter"
      phx-value-letter={@letter}
      class={["pt-1 pb-1 rounded uppercase", classes(@color)]}
    >
      <%= @letter %>
    </div>
    """
  end

  def classes(:green), do: "bg-green-600 text-white"
  def classes(:yellow), do: "bg-yellow-500 text-white"
  def classes(:gray), do: "bg-gray-500 text-white"
  def classes(:white), do: "text-black border-solid border-2 border-slate-600"
end
