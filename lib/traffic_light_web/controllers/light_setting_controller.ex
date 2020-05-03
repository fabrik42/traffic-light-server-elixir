defmodule TrafficLightWeb.LightSettingController do
  use TrafficLightWeb, :controller

  alias TrafficLight.LightSettingServer

  def show(conn, _params) do
    {:ok, light_setting} = LightSettingServer.get()
    render(conn, "show.json", light_setting: light_setting)
  end
end
