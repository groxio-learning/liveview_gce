defmodule Wordex.GameLiveTest do
  use Wordex.DataCase

  import Phoenix.LiveViewTest

  alias WordexWeb.GameLive

  describe "word_letter/1" do
    test "renders letter with green background" do
      assert render_component(&GameLive.word_letter/1, letter: "B", color: :green) =~
         ~r/<div class="bg-green-600 text-white pt-2 pb-2 rounded">B<\/div>/
    end

    test "renders letter with yellow background" do
      assert render_component(&GameLive.word_letter/1, letter: "B", color: :yellow) =~
         ~r/<div class="bg-yellow-500 text-white pt-2 pb-2 rounded">B<\/div>/
    end

    test "renders letter with gray background" do
      assert render_component(&GameLive.word_letter/1, letter: "B", color: :gray) =~
         ~r/<div class="bg-gray-500 text-white pt-2 pb-2 rounded">B<\/div>/
    end

    test "renders empty string with white background" do
      assert render_component(&GameLive.word_letter/1, letter: "", color: :white) =~
         ~r/<div class="bg-white-500 border text-black pt-2 pb-2 rounded"><\/div>/
    end

    test "renders nil with white background" do
      assert render_component(&GameLive.word_letter/1, letter: nil, color: :white) =~
         ~r/<div class="bg-white-500 border text-black pt-2 pb-2 rounded"><\/div>/
    end

    test "renders active guess letter with white background and strong border" do
      assert render_component(&GameLive.word_letter/1, letter: "X", color: :white) =~
         ~r/<div class="bg-white-500 border-black border-2 text-black pt-2 pb-2 rounded">X<\/div>/
    end
  end
end
