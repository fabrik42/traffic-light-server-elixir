defmodule TrafficLightWeb.LightSettingView do
  use TrafficLightWeb, :view
  alias TrafficLightWeb.LightSettingView
  alias TrafficLight.LightSetting

  def render("show.json", %{light_setting: light_setting}) do
    %{data: render_one(light_setting, LightSettingView, "light_setting.json")}
  end

  def render("light_setting.json", %{light_setting: light_setting}) do
    LightSetting.as_json(light_setting)
  end
end
