defmodule TrafficLightWeb.Webhook.CodeshipControllerTest do
  use TrafficLightWeb.ConnCase

  alias TrafficLight.{Factory, LightSetting}

  setup %{conn: conn} do
    {:ok,
     conn: put_req_header(conn, "content-type", "application/json"), token: "MY-SECRET-CI-TOKEN"}
  end

  test "update the build status", %{conn: conn, token: token} do
    red = LightSetting.build(mode: "ci", red: true)
    {:ok, _} = LightSetting.save(red, "ci")
    assert LightSetting.load("ci") == {:ok, red}

    payload = Factory.build(:codeship_payload, %{status: "success"})
    conn = post(conn, Routes.codeship_path(conn, :create, token: token), payload)

    assert %{"success" => true} == json_response(conn, 201)

    green = LightSetting.build(mode: "ci", green: true)
    assert LightSetting.load("ci") == {:ok, green}
  end

  test "don't update the build status with invalid data", %{conn: conn, token: token} do
    red = LightSetting.build(mode: "ci", red: true)
    {:ok, _} = LightSetting.save(red, "ci")
    assert LightSetting.load("ci") == {:ok, red}

    payload = Factory.build(:codeship_payload, %{status: "UNKNOWN_STATE"})
    conn = post(conn, Routes.codeship_path(conn, :create, token: token), payload)

    expected = %{"success" => false, "error" => "Unknown build state: UNKNOWN_STATE"}

    assert expected == json_response(conn, 422)
    assert LightSetting.load("ci") == {:ok, red}
  end

  test "don't update the build status without valid token", %{conn: conn} do
    payload = Factory.build(:codeship_payload, %{status: "UNKNOWN_STATE"})
    conn = post(conn, Routes.codeship_path(conn, :create), payload)

    assert "Unauthorized" == response(conn, 401)
  end
end
