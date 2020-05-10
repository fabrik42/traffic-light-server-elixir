defmodule TrafficLight.LightSetting.ViewHelperTest do
  use ExUnit.Case
  doctest TrafficLight.LightSetting.ViewHelper

  alias TrafficLight.LightSetting
  alias TrafficLight.LightSetting.ViewHelper

  test "switch_value" do
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    assert ViewHelper.switch_value(light_setting, :red) == "on"
    assert ViewHelper.switch_value(light_setting, :green) == "off"
  end

  test "opposite_switch_value" do
    light_setting = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    assert ViewHelper.opposite_switch_value(light_setting, :red) == "off"
    assert ViewHelper.opposite_switch_value(light_setting, :green) == "on"
  end

  test "top_bar_class_name" do
    red_only = %LightSetting{mode: "ci", red: true, yellow: false, green: false}
    assert ViewHelper.top_bar_class_name(red_only) == "red"

    yellow_only = %LightSetting{mode: "ci", red: false, yellow: true, green: false}
    assert ViewHelper.top_bar_class_name(yellow_only) == "yellow"

    green_only = %LightSetting{mode: "ci", red: false, yellow: false, green: true}
    assert ViewHelper.top_bar_class_name(green_only) == "green"

    multi = %LightSetting{mode: "ci", red: true, yellow: true, green: false}
    assert ViewHelper.top_bar_class_name(multi) == ""
  end
end
