defmodule TrafficLight.LightSetting.WebhookParser.GithubTest do
  use ExUnit.Case
  doctest TrafficLight.LightSetting.WebhookParser.Github

  alias TrafficLight.{Factory, LightSetting}
  alias TrafficLight.LightSetting.WebhookParser.Github

  test "from github, a check run event with unknown build state" do
    payload = Factory.build(:github_payload, %{status: "unknown_state"})
    assert Github.from_payload(payload) == {:error, "Unknown build state: unknown_state"}
  end

  test "from github with in-progress build state" do
    states = ["pending"]

    Enum.each(states, fn state ->
      payload = Factory.build(:github_payload, %{status: state})
      expected = %LightSetting{green: false, mode: "ci", red: false, yellow: true}
      assert Github.from_payload(payload) == {:ok, expected}
    end)
  end

  test "from github with erroneous build state" do
    states = ["failure", "error"]

    Enum.each(states, fn state ->
      payload = Factory.build(:github_payload, %{status: state})
      expected = %LightSetting{green: false, mode: "ci", red: true, yellow: false}
      assert Github.from_payload(payload) == {:ok, expected}
    end)
  end

  test "from github with successful build state" do
    states = ["success"]

    Enum.each(states, fn state ->
      payload = Factory.build(:github_payload, %{status: state})
      expected = %LightSetting{green: true, mode: "ci", red: false, yellow: false}
      assert Github.from_payload(payload) == {:ok, expected}
    end)
  end
end
