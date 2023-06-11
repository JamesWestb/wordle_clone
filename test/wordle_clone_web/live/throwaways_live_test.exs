defmodule WordleCloneWeb.ThrowawaysLiveTest do
  use WordleCloneWeb.ConnCase

  import Phoenix.LiveViewTest
  import WordleClone.ThrowawayFixtures

  @create_attrs %{throwaway: "some throwaway"}
  @update_attrs %{throwaway: "some updated throwaway"}
  @invalid_attrs %{throwaway: nil}

  defp create_throwaways(_) do
    throwaways = throwaways_fixture()
    %{throwaways: throwaways}
  end

  describe "Index" do
    setup [:create_throwaways]

    test "lists all throwaways", %{conn: conn, throwaways: throwaways} do
      {:ok, _index_live, html} = live(conn, Routes.throwaways_index_path(conn, :index))

      assert html =~ "Listing Throwaways"
      assert html =~ throwaways.throwaway
    end

    test "saves new throwaways", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.throwaways_index_path(conn, :index))

      assert index_live |> element("a", "New Throwaways") |> render_click() =~
               "New Throwaways"

      assert_patch(index_live, Routes.throwaways_index_path(conn, :new))

      assert index_live
             |> form("#throwaways-form", throwaways: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#throwaways-form", throwaways: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.throwaways_index_path(conn, :index))

      assert html =~ "Throwaways created successfully"
      assert html =~ "some throwaway"
    end

    test "updates throwaways in listing", %{conn: conn, throwaways: throwaways} do
      {:ok, index_live, _html} = live(conn, Routes.throwaways_index_path(conn, :index))

      assert index_live |> element("#throwaways-#{throwaways.id} a", "Edit") |> render_click() =~
               "Edit Throwaways"

      assert_patch(index_live, Routes.throwaways_index_path(conn, :edit, throwaways))

      assert index_live
             |> form("#throwaways-form", throwaways: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#throwaways-form", throwaways: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.throwaways_index_path(conn, :index))

      assert html =~ "Throwaways updated successfully"
      assert html =~ "some updated throwaway"
    end

    test "deletes throwaways in listing", %{conn: conn, throwaways: throwaways} do
      {:ok, index_live, _html} = live(conn, Routes.throwaways_index_path(conn, :index))

      assert index_live |> element("#throwaways-#{throwaways.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#throwaways-#{throwaways.id}")
    end
  end

  describe "Show" do
    setup [:create_throwaways]

    test "displays throwaways", %{conn: conn, throwaways: throwaways} do
      {:ok, _show_live, html} = live(conn, Routes.throwaways_show_path(conn, :show, throwaways))

      assert html =~ "Show Throwaways"
      assert html =~ throwaways.throwaway
    end

    test "updates throwaways within modal", %{conn: conn, throwaways: throwaways} do
      {:ok, show_live, _html} = live(conn, Routes.throwaways_show_path(conn, :show, throwaways))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Throwaways"

      assert_patch(show_live, Routes.throwaways_show_path(conn, :edit, throwaways))

      assert show_live
             |> form("#throwaways-form", throwaways: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#throwaways-form", throwaways: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.throwaways_show_path(conn, :show, throwaways))

      assert html =~ "Throwaways updated successfully"
      assert html =~ "some updated throwaway"
    end
  end
end
