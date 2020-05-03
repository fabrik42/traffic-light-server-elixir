defmodule TrafficLightWeb.LightSettingControllerTest do
  use TrafficLightWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "show the light settings", %{conn: conn} do
    conn = get(conn, Routes.light_setting_path(conn, :show))
    response = %{"green" => true, "mode" => "ci", "red" => true, "yellow" => true}

    assert response == json_response(conn, 200)["data"]
  end
end
