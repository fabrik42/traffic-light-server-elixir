defmodule TrafficLightWeb.PageLive do
  use TrafficLightWeb, :live_view

  alias TrafficLight.LightSetting
  alias TrafficLight.LightSettingServer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, light_setting} = LightSettingServer.get()

    if connected?(socket), do: LightSettingServer.subscribe()

    initial_socket =
      socket
      |> assign(light_setting: light_setting)

    {:ok, initial_socket}
  end

  @impl true
  def handle_event("set_color", %{"color" => color, "new-state" => new_state}, socket) do
    case LightSetting.update_color(socket.assigns.light_setting, color, new_state) do
      {:ok, new_setting} -> LightSettingServer.set(new_setting)
      _ -> nil
    end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:light_setting_update, light_setting}, socket) do
    # TODO: only assign if light_setting.mode == current_mode
    {:noreply, assign(socket, :light_setting, light_setting)}
  end
end
