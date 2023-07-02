defmodule WordleClone.WordBank.WordFactory do
  defmacro __using__(_opts) do
    quote do
      def word_factory(attrs \\ %{}) do
        word = %WordleClone.WordBank.Word{
          name: "valid",
          game_solution: false
        }

        merge_attributes(word, attrs)
      end
    end
  end
end
