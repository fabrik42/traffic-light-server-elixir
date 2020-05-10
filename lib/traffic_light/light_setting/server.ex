defmodule TrafficLight.LightSetting.Server do
  use GenServer

  alias TrafficLight.LightSetting

  # Client

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: LightSettingLink)
  end

  def get(light_mode) do
    GenServer.call(LightSettingLink, {:get, light_mode})
  end

  def set(light_mode, light_setting) do
    GenServer.call(LightSettingLink, {:set, light_mode, light_setting})
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(TrafficLight.PubSub, "light_setting_server")
  end

  # Callbacks

  @impl true
  def init(default_state) do
    redis_url = Application.get_env(:traffic_light, :redis)[:url]
    {:ok, conn} = Redix.start_link(redis_url)

    state =
      default_state
      |> Map.put(:conn, conn)

    {:ok, state}
  end

  @impl true
  def handle_call({:get, light_mode}, _from, %{conn: conn} = state) do
    result = Redix.command(conn, ["GET", key(light_mode)])

    return_value =
      case result do
        {:error, error} -> {:error, error}
        {:ok, raw} -> {:ok, LightSetting.from_json(raw)}
      end

    {:reply, return_value, state}
  end

  @impl true
  def handle_call({:set, light_mode, light_setting}, _from, %{conn: conn} = state) do
    json = LightSetting.to_json(light_setting)

    {:ok, _} = Redix.command(conn, ["SET", key(light_mode), json])
    broadcast(light_setting)

    {:reply, {:ok, light_setting}, state}
  end

  defp broadcast(light_setting) do
    Phoenix.PubSub.broadcast(
      TrafficLight.PubSub,
      "light_setting_server",
      {:light_setting_update, light_setting}
    )
  end

  defp key(light_mode) do
    "trafficlight:" <> light_mode
  end
end
