defmodule Aht20TrackerWeb.ErrorJSONTest do
  use Aht20TrackerWeb.ConnCase, async: true

  test "renders 404" do
    assert Aht20TrackerWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Aht20TrackerWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
