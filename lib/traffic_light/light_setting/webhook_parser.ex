defmodule TrafficLight.LightSetting.WebhookParser do
  alias TrafficLight.LightSetting

  @codeship_state_map %{
    "error" => :red,
    "stopped" => :red,
    "ignored" => :red,
    "blocked" => :red,
    "infrastructure_failure" => :red,
    "initiated" => :yellow,
    "waiting" => :yellow,
    "testing" => :yellow,
    "success" => :green
  }

  def from_codeship(raw_json) do
    with(
      {:ok, payload} <- Poison.decode(raw_json),
      {:ok, color} <- color_from_status(payload)
    ) do
      light_setting =
        LightSetting.build()
        |> Map.put(:mode, "ci")
        |> Map.put(color, true)

      {:ok, light_setting}
    else
      {:error, error_message} -> {:error, error_message}
    end
  end

  def color_from_status(payload) do
    status = get_in(payload, ["build", "status"])

    case Map.get(@codeship_state_map, status) do
      nil -> {:error, "Unknown build state: #{status}"}
      color -> {:ok, color}
    end
  end
end
