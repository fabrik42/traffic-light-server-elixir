defmodule TrafficLight.LightSetting.WebhookParserTest do
  use ExUnit.Case
  doctest TrafficLight.LightSetting.WebhookParser

  alias TrafficLight.LightSetting
  alias TrafficLight.LightSetting.WebhookParser

  test "from codeship with unknown build sate" do
    payload = build_payload("another_state")
    assert WebhookParser.from_codeship(payload) == {:error, "Unknown build state: another_state"}
  end

  test "from codeship for erroneous states" do
    states = ["error", "stopped", "ignored", "blocked", "infrastructure_failure"]

    Enum.each(states, fn state ->
      payload = build_payload(state)
      expected = %LightSetting{green: false, mode: "ci", red: true, yellow: false}
      assert WebhookParser.from_codeship(payload) == {:ok, expected}
    end)
  end

  test "from codeship for pending states" do
    states = ["initiated", "waiting", "testing"]

    Enum.each(states, fn state ->
      payload = build_payload(state)
      expected = %LightSetting{green: false, mode: "ci", red: false, yellow: true}
      assert WebhookParser.from_codeship(payload) == {:ok, expected}
    end)
  end

  test "from codeship for succeeded states" do
    states = ["success"]

    Enum.each(states, fn state ->
      payload = build_payload(state)
      expected = %LightSetting{green: true, mode: "ci", red: false, yellow: false}
      assert WebhookParser.from_codeship(payload) == {:ok, expected}
    end)
  end

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
