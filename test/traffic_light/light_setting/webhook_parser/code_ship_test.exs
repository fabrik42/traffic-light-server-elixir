defmodule TrafficLight.LightSetting.WebhookParser.CodeShipTest do
  use ExUnit.Case
  doctest TrafficLight.LightSetting.WebhookParser.CodeShip

  alias TrafficLight.{Factory, LightSetting}
  alias TrafficLight.LightSetting.WebhookParser.CodeShip

  test "from codeship with unknown build sate" do
    payload = Factory.build(:codeship_payload, %{status: "another_state"})
    assert CodeShip.from_payload(payload) == {:error, "Unknown build state: another_state"}
  end

  test "from codeship for erroneous states" do
    states = ["error", "stopped", "ignored", "blocked", "infrastructure_failure"]

    Enum.each(states, fn state ->
      payload = Factory.build(:codeship_payload, %{status: state})
      expected = %LightSetting{green: false, mode: "ci", red: true, yellow: false}
      assert CodeShip.from_payload(payload) == {:ok, expected}
    end)
  end

  test "from codeship for pending states" do
    states = ["initiated", "waiting", "testing"]

    Enum.each(states, fn state ->
      payload = Factory.build(:codeship_payload, %{status: state})
      expected = %LightSetting{green: false, mode: "ci", red: false, yellow: true}
      assert CodeShip.from_payload(payload) == {:ok, expected}
    end)
  end

  test "from codeship for succeeded states" do
    states = ["success"]

    Enum.each(states, fn state ->
      payload = Factory.build(:codeship_payload, %{status: state})
      expected = %LightSetting{green: true, mode: "ci", red: false, yellow: false}
      assert CodeShip.from_payload(payload) == {:ok, expected}
    end)
  end
end
