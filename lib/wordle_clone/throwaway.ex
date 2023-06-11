defmodule WordleClone.Throwaway do
  @moduledoc """
  The Throwaway context.
  """

  import Ecto.Query, warn: false
  alias WordleClone.Repo

  alias WordleClone.Throwaway.Throwaways

  @doc """
  Returns the list of throwaways.

  ## Examples

      iex> list_throwaways()
      [%Throwaways{}, ...]

  """
  def list_throwaways do
    Repo.all(Throwaways)
  end

  @doc """
  Gets a single throwaways.

  Raises `Ecto.NoResultsError` if the Throwaways does not exist.

  ## Examples

      iex> get_throwaways!(123)
      %Throwaways{}

      iex> get_throwaways!(456)
      ** (Ecto.NoResultsError)

  """
  def get_throwaways!(id), do: Repo.get!(Throwaways, id)

  @doc """
  Creates a throwaways.

  ## Examples

      iex> create_throwaways(%{field: value})
      {:ok, %Throwaways{}}

      iex> create_throwaways(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_throwaways(attrs \\ %{}) do
    %Throwaways{}
    |> Throwaways.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a throwaways.

  ## Examples

      iex> update_throwaways(throwaways, %{field: new_value})
      {:ok, %Throwaways{}}

      iex> update_throwaways(throwaways, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_throwaways(%Throwaways{} = throwaways, attrs) do
    throwaways
    |> Throwaways.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a throwaways.

  ## Examples

      iex> delete_throwaways(throwaways)
      {:ok, %Throwaways{}}

      iex> delete_throwaways(throwaways)
      {:error, %Ecto.Changeset{}}

  """
  def delete_throwaways(%Throwaways{} = throwaways) do
    Repo.delete(throwaways)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking throwaways changes.

  ## Examples

      iex> change_throwaways(throwaways)
      %Ecto.Changeset{data: %Throwaways{}}

  """
  def change_throwaways(%Throwaways{} = throwaways, attrs \\ %{}) do
    Throwaways.changeset(throwaways, attrs)
  end
end
