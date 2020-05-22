defmodule TrafficLight.LightSetting.ViewHelper do
  @moduledoc """
  Collection of helper functions to be used for rendering the light setting of the traffic light.
  """

  def switch_value(light_setting, color) do
    value = Map.get(light_setting, color)
    if value, do: "on", else: "off"
  end

  def opposite_switch_value(light_setting, color) do
    value = switch_value(light_setting, color)
    if value == "off", do: "on", else: "off"
  end

  def top_bar_class_name(%{red: true, yellow: false, green: false}), do: "red"
  def top_bar_class_name(%{red: false, yellow: true, green: false}), do: "yellow"
  def top_bar_class_name(%{red: false, yellow: false, green: true}), do: "green"
  def top_bar_class_name(_light_setting), do: ""
end
