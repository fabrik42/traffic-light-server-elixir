defmodule TrafficLight.LightSetting.ServerTest do
  use ExUnit.Case
  doctest TrafficLight.LightSetting.Server

  alias TrafficLight.LightSetting
  alias TrafficLight.LightSetting.Server

  test "Persist the light setting" do
    light_setting = LightSetting.build(mode: "ci", green: true)

    {:ok, _} = Server.set("ci", light_setting)
    {:ok, loaded} = Server.get("ci")
    assert light_setting == loaded
  end

  test "Differentiate between the light modes" do
    setting_ci = LightSetting.build(mode: "ci", yellow: true)
    setting_public = LightSetting.build(mode: "public", red: true)

    {:ok, _} = Server.set("ci", setting_ci)
    {:ok, _} = Server.set("public", setting_public)

    {:ok, loaded_ci} = Server.get("ci")
    assert setting_ci == loaded_ci

    {:ok, loaded_public} = Server.get("public")
    assert setting_public == loaded_public
  end

  test "Broadcast when current light mode is updated" do
    assert LightSetting.current_mode() == "public"
    Server.subscribe()

    setting_public = LightSetting.build(mode: "public", green: true)
    {:ok, _} = Server.set("public", setting_public)

    assert_received {:light_setting_update,
                     %TrafficLight.LightSetting{
                       green: true,
                       mode: "public",
                       red: false,
                       yellow: false
                     }}
  end

  test "No broadcast when inactive light mode is updated" do
    assert LightSetting.current_mode() == "public"
    Server.subscribe()

    setting_ci = LightSetting.build(mode: "ci", green: true)
    {:ok, _} = Server.set("ci", setting_ci)

    refute_received {:light_setting_update,
                     %TrafficLight.LightSetting{
                       green: true,
                       mode: "ci",
                       red: false,
                       yellow: false
                     }}
  end
end
