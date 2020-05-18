defmodule TrafficLightWeb.Webhook.CodeshipControllerTest do
  use TrafficLightWeb.ConnCase

  alias TrafficLight.LightSetting

  setup %{conn: conn} do
    {:ok,
     conn: put_req_header(conn, "content-type", "application/json"), token: "MY-SECRET-CI-TOKEN"}
  end

  test "update the build status", %{conn: conn, token: token} do
    red = LightSetting.build(mode: "ci", red: true)
    {:ok, _} = LightSetting.save(red, "ci")
    assert LightSetting.load("ci") == {:ok, red}

    payload = build_payload("success")
    conn = post(conn, Routes.codeship_path(conn, :create, token: token), payload)

    assert %{"success" => true} == json_response(conn, 201)

    green = LightSetting.build(mode: "ci", green: true)
    assert LightSetting.load("ci") == {:ok, green}
  end

  test "don't update the build status with invalid data", %{conn: conn, token: token} do
    red = LightSetting.build(mode: "ci", red: true)
    {:ok, _} = LightSetting.save(red, "ci")
    assert LightSetting.load("ci") == {:ok, red}

    payload = build_payload("UNKNOWN_STATE")
    conn = post(conn, Routes.codeship_path(conn, :create, token: token), payload)

    expected = %{"success" => false, "error" => "Unknown build state: UNKNOWN_STATE"}

    assert expected == json_response(conn, 422)
    assert LightSetting.load("ci") == {:ok, red}
  end

  test "don't update the build status without valid token", %{conn: conn} do
    payload = build_payload("UNKNOWN_STATE")
    conn = post(conn, Routes.codeship_path(conn, :create), payload)

    assert "Unauthorized" == response(conn, 401)
  end

  # TODO: deduplicate and move to test helpers
  # idea: build(:codeship_webhook_payload) like factory
  # Payload taken from https://documentation.codeship.com/general/projects/notifications/
  def build_payload(status) do
    Poison.decode!(~s(
          {
            "build": {
              "build_url":"https://www.codeship.com/projects/10213/builds/973711",
              "commit_url":"https://github.com/codeship/docs/
              commit/96943dc5269634c211b6fbb18896ecdcbd40a047",
              "project_id":10213,
              "build_id":973711,
              "status":"#{status}",
              "project_full_name":"codeship/docs",
              "project_name":"codeship/docs",
              "commit_id":"96943dc5269634c211b6fbb18896ecdcbd40a047",
              "short_commit_id":"96943",
              "message":"Merge pull request #34 from codeship/feature/shallow-clone",
              "committer":"beanieboi",
              "branch":"master"
            }
          }
        ))
  end
end
