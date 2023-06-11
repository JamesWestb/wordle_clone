defmodule WordleClone.ThrowawayTest do
  use WordleClone.DataCase

  alias WordleClone.Throwaway

  describe "throwaways" do
    alias WordleClone.Throwaway.Throwaways

    import WordleClone.ThrowawayFixtures

    @invalid_attrs %{throwaway: nil}

    test "list_throwaways/0 returns all throwaways" do
      throwaways = throwaways_fixture()
      assert Throwaway.list_throwaways() == [throwaways]
    end

    test "get_throwaways!/1 returns the throwaways with given id" do
      throwaways = throwaways_fixture()
      assert Throwaway.get_throwaways!(throwaways.id) == throwaways
    end

    test "create_throwaways/1 with valid data creates a throwaways" do
      valid_attrs = %{throwaway: "some throwaway"}

      assert {:ok, %Throwaways{} = throwaways} = Throwaway.create_throwaways(valid_attrs)
      assert throwaways.throwaway == "some throwaway"
    end

    test "create_throwaways/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Throwaway.create_throwaways(@invalid_attrs)
    end

    test "update_throwaways/2 with valid data updates the throwaways" do
      throwaways = throwaways_fixture()
      update_attrs = %{throwaway: "some updated throwaway"}

      assert {:ok, %Throwaways{} = throwaways} = Throwaway.update_throwaways(throwaways, update_attrs)
      assert throwaways.throwaway == "some updated throwaway"
    end

    test "update_throwaways/2 with invalid data returns error changeset" do
      throwaways = throwaways_fixture()
      assert {:error, %Ecto.Changeset{}} = Throwaway.update_throwaways(throwaways, @invalid_attrs)
      assert throwaways == Throwaway.get_throwaways!(throwaways.id)
    end

    test "delete_throwaways/1 deletes the throwaways" do
      throwaways = throwaways_fixture()
      assert {:ok, %Throwaways{}} = Throwaway.delete_throwaways(throwaways)
      assert_raise Ecto.NoResultsError, fn -> Throwaway.get_throwaways!(throwaways.id) end
    end

    test "change_throwaways/1 returns a throwaways changeset" do
      throwaways = throwaways_fixture()
      assert %Ecto.Changeset{} = Throwaway.change_throwaways(throwaways)
    end
  end
end
