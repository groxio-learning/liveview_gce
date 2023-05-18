defmodule WordexWeb.GameLive do
  use WordexWeb, :live_view
  alias Wordex.Game
  alias WordexWeb.KeyboardKey
  alias Wordex.Game.Input
  alias Ecto.Changeset

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:changeset, changeset())
     |> in_progress_game()}
  end

  def changeset(params \\ %{}) do
    input = %Input{}
    types = %{guess: :string}

    {input, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_length(:guess, is: 5)
    |> validate_inclusion_in_dicionary()
  end

  def validate_inclusion_in_dicionary(changeset) do
    guess = Changeset.get_field(changeset, :guess)

    cond do
      Wordex.Words.member?(guess) -> changeset
      true -> Ecto.Changeset.add_error(changeset, :guess, "Word not in dictionary")
    end
  end

  def handle_event("input", params, socket) do
    {
      :noreply,
      socket
      |> assign(:changeset, changeset(params))
    }
  end

  def handle_event("submit", %{"guess" => guess}, socket) do
    if socket.assigns.changeset.valid? do
      {:noreply, socket |> guess(guess)}
    else
      {:noreply, socket}
    end
  end

  def guess(%{assigns: %{game: game}} = socket, guess) do
    game =
      game
      |> Game.guess(guess)

    result = Game.render(game)

    socket
    |> assign(:game, game)
    |> assign(:result, result)
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
    <div class="flex flex-col gap-6">
      <.word_grid scores={@game.scores} />

      <.form
        class="flex flex-col gap-2 cursor-pointer"
        phx-change="input"
        phx-submit="submit"
        for={@changeset}
      >
        <.input type="text" placeholder="guess" name="guess" value="" />
        <input
          class={[
            "rounded-md p-2",
            if @changeset.valid? do
              "bg-green-600"
            else
              "bg-gray-600"
            end
          ]}
          type="submit"
          value="Submit"
        />
      </.form>

      <pre><%= inspect(@changeset, pretty: true) %></pre>

      <div class="grid grid-cols-10 gap-3 text-center font-bold">
        <%= for {letter, color} <- @result.keyboard do %>
          <KeyboardKey.key letter={letter} color={color} />
        <% end %>
      </div>
    </div>
    """
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
    <div class="grid grid-cols-5 gap-4 text-center font-bold">
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
    <div class="grid grid-cols-5 gap-4 text-center font-bold">
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
    <div class="grid grid-cols-10 gap-3 text-center font-bold">
      <%= for i <- keyboard_rows() do %>
        <.keyboard_row letters={i} />
      <% end %>
    </div>
    """
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
      class="bg-green-600 text-white pt-2 pb-2 rounded"
      phx-click="guess"
      phx-value-letter={@letter}
    >
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
