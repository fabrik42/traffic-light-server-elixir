defmodule TrafficLightWeb.PageLive do
  use TrafficLightWeb, :live_view

  alias TrafficLight.LightSetting
  alias TrafficLight.LightSetting.ViewHelper

  @impl true
  def mount(_params, _session, socket) do
    {:ok, light_setting} = LightSetting.load()

    if connected?(socket), do: LightSetting.subscribe()

    initial_socket =
      socket
      |> assign(light_setting: light_setting)

    {:ok, initial_socket}
  end

  @impl true
  def handle_event("set_color", %{"color" => color, "new-state" => new_state}, socket) do
    if LightSetting.website_update_allowed?() do
      update_light_settings(socket.assigns.light_setting, color, new_state)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:light_setting_update, light_setting}, socket) do
    {:noreply, assign(socket, :light_setting, light_setting)}
  end

  defp update_light_settings(light_setting, color, new_state) do
    case LightSetting.update_color(light_setting, color, new_state) do
      {:ok, new_setting} -> LightSetting.save(new_setting)
      _ -> nil
    end
  end
end
