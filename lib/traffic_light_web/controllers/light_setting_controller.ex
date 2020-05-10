defmodule TrafficLightWeb.LightSettingController do
  use TrafficLightWeb, :controller

  alias TrafficLight.LightSetting

  def show(conn, _params) do
    {:ok, light_setting} = LightSetting.load()
    render(conn, "show.json", light_setting: light_setting)
  end
end
