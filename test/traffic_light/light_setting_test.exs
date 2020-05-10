defmodule TrafficLight.LightSettingTest do
  use ExUnit.Case
  doctest TrafficLight.LightSetting

  alias TrafficLight.LightSetting

  test "build" do
    light_setting = %LightSetting{mode: "public", red: false, yellow: false, green: false}
    assert LightSetting.build() == light_setting
  end

  test "ordered colors" do
    assert LightSetting.ordered_colors() == [:red, :yellow, :green]
  end

  test "returns current mode" do
    assert LightSetting.current_mode() == "public"
  end

  test "website_update_allowed?" do
    assert LightSetting.current_mode() == "public"
    assert LightSetting.website_update_allowed?() == true
  end

  test "is a struct" do
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    assert light_setting.mode == "ci"
    assert light_setting.red == true
    assert light_setting.yellow == false
    assert light_setting.green == false
  end

  test "as_json" do
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    map = LightSetting.as_json(light_setting)

    assert map == %{mode: "ci", red: true, yellow: false, green: false}
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

  test "update_color with valid input" do
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    color = "red"
    value = "off"
    updated = %LightSetting{mode: "ci", red: false, yellow: false, green: false}

    assert LightSetting.update_color(light_setting, color, value) == {:ok, updated}

    color = "green"
    value = "on"
    updated = %LightSetting{mode: "ci", red: true, yellow: false, green: true}

    assert LightSetting.update_color(light_setting, color, value) == {:ok, updated}
  end

  test "update_color with invalid input" do
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    color = "SOMETHING_INVALID"
    value = "off"
    expected = {:error, "Invalid data given! color: SOMETHING_INVALID, state: off"}

    assert LightSetting.update_color(light_setting, color, value) == expected
  end
end
