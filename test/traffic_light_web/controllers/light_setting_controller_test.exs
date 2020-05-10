defmodule TrafficLightWeb.LightSettingControllerTest do
  use TrafficLightWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    ls = TrafficLight.LightSetting.build()
    {:ok, _} = TrafficLight.LightSettingServer.set(ls)
    :ok
  end

  test "show the light settings", %{conn: conn} do
    conn = get(conn, Routes.light_setting_path(conn, :show))
    response = %{"green" => false, "mode" => "ci", "red" => false, "yellow" => false}

    assert response == json_response(conn, 200)
  end
end
