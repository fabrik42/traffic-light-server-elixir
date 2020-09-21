defmodule TrafficLight.LightSetting.WebhookParser.Codeship do
  @moduledoc """
  Parses the payload sent through webhooks by Codeship.
  """

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

  def from_payload(payload) do
    case color_from_status(payload) do
      {:ok, color} ->
        light_setting =
          LightSetting.build()
          |> Map.put(:mode, "ci")
          |> Map.put(color, true)

        {:ok, light_setting}

      {:error, error_message} ->
        {:error, error_message}
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
