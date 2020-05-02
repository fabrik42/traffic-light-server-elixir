defmodule TrafficLight.LightSettingTest do
  use ExUnit.Case
  doctest TrafficLight.LightSetting

  alias TrafficLight.LightSetting

  test "returns current mode" do
    assert LightSetting.current_mode() == "ci"
  end

  test "is a struct" do
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    assert light_setting.mode == "ci"
    assert light_setting.red == true
    assert light_setting.yellow == false
    assert light_setting.green == false
  end

  test "to_json" do
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    json = LightSetting.to_json(light_setting)

    assert json == ~s({"yellow":false,"red":true,"mode":"ci","green":false})
  end

  test "from_json" do
    json = ~s({"yellow":false,"red":true,"mode":"ci","green":false})
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}

    parsed = LightSetting.from_json(json)
    assert parsed == light_setting
  end

  test "from_json is nil-safe" do
    parsed = LightSetting.from_json(nil)
    assert parsed == nil
  end
end
