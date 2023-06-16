defmodule WordleClone.WordBank.WordFactory do
  defmacro __using__(_opts) do
    quote do
      def word_factory(attrs \\ %{}) do
        %WordleClone.WordBank.Word{
          name: "valid"
        }
      end
    end
  end
end
