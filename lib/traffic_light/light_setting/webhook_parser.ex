defmodule TrafficLight.LightSetting.WebhookParser do
  alias TrafficLight.LightSetting

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
    do_color_from_status(status)
  end

  defp do_color_from_status(status)
       when status in ["error", "stopped", "ignored", "blocked", "infrastructure_failure"],
       do: {:ok, :red}

  defp do_color_from_status(status) when status in ["initiated", "waiting", "testing"],
    do: {:ok, :yellow}

  defp do_color_from_status(status) when status in ["success"], do: {:ok, :green}
  defp do_color_from_status(status), do: {:error, "Unknown build state: #{status}"}
end
