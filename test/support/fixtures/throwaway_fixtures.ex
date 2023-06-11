defmodule WordleClone.ThrowawayFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WordleClone.Throwaway` context.
  """

  @doc """
  Generate a throwaways.
  """
  def throwaways_fixture(attrs \\ %{}) do
    {:ok, throwaways} =
      attrs
      |> Enum.into(%{
        throwaway: "some throwaway"
      })
      |> WordleClone.Throwaway.create_throwaways()

    throwaways
  end
end
