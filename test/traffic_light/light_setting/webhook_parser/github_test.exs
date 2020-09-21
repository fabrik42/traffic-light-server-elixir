defmodule TrafficLight.LightSetting.WebhookParser.GitHubTest do
  use ExUnit.Case
  doctest TrafficLight.LightSetting.WebhookParser.GitHub

  alias TrafficLight.{Factory, LightSetting}
  alias TrafficLight.LightSetting.WebhookParser.GitHub

  test "from github, a check run event with unknown build state" do
    payload = Factory.build(:github_payload, %{event: "check_run", status: "unknown_state"})
    assert GitHub.from_payload(payload) == {:error, "Unknown build state: unknown_state"}
  end

  test "from github, a check run event with in-progress build state" do
    states = ["queued", "in_progress"]

    Enum.each(states, fn state ->
      payload = Factory.build(:github_payload, %{event: "check_run", status: state})
      expected = %LightSetting{green: false, mode: "ci", red: false, yellow: true}
      assert GitHub.from_payload(payload) == {:ok, expected}
    end)
  end

  test "from github, a check suite event with unknown build state" do
    payload = Factory.build(:github_payload, %{event: "check_suite", status: "unknown_state"})
    assert GitHub.from_payload(payload) == {:error, "Unknown build state: unknown_state"}
  end

  test "from github, a check suite event with indifferent build state" do
    states = ["neutral", "action_required"]

    Enum.each(states, fn state ->
      payload = Factory.build(:github_payload, %{event: "check_suite", status: state})
      expected = %LightSetting{green: false, mode: "ci", red: false, yellow: true}
      assert GitHub.from_payload(payload) == {:ok, expected}
    end)
  end

  test "from github, a check suite event with erroneous build state" do
    states = ["failure", "cancelled", "timed_out", "stale"]

    Enum.each(states, fn state ->
      payload = Factory.build(:github_payload, %{event: "check_suite", status: state})
      expected = %LightSetting{green: false, mode: "ci", red: true, yellow: false}
      assert GitHub.from_payload(payload) == {:ok, expected}
    end)
  end

  test "from github, a check suite event with successful build state" do
    states = ["success"]

    Enum.each(states, fn state ->
      payload = Factory.build(:github_payload, %{event: "check_suite", status: state})
      expected = %LightSetting{green: true, mode: "ci", red: false, yellow: false}
      assert GitHub.from_payload(payload) == {:ok, expected}
    end)
  end
end
