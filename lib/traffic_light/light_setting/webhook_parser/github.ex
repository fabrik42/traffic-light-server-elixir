defmodule TrafficLight.LightSetting.WebhookParser.Github do
  @moduledoc """
  Parses the payload sent through webhooks by GitHub.
  """

  alias TrafficLight.LightSetting

  @github_state_map %{
    "failure" => :red,
    "error" => :red,
    "pending" => :yellow,
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
    status = get_in(payload, ["state"])

    case Map.get(@github_state_map, status) do
      nil -> {:error, "Unknown build state: #{status}"}
      color -> {:ok, color}
    end
  end
end
