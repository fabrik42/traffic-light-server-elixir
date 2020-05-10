defmodule TrafficLightWeb.LightSettingView do
  use TrafficLightWeb, :view
  alias TrafficLight.LightSetting

  def render("show.json", %{light_setting: light_setting}) do
    LightSetting.as_json(light_setting)
  end
end
