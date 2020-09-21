defmodule TrafficLight.LightSetting.WebhookParser.GitHub do
  @moduledoc """
  Parses the payload sent through webhooks by GitHub.
  """

  alias TrafficLight.LightSetting

  @github_state_map %{
    "failure" => :red,
    "cancelled" => :red,
    "timed_out" => :red,
    "stale" => :red,
    "queued" => :yellow,
    "in_progress" => :yellow,
    "neutral" => :yellow,
    "action_required" => :yellow,
    "success" => :green
  }

  def from_payload(payload) when is_map_key(payload, "check_run") do
    status = get_in(payload, ["check_run", "status"])
    set_color_from_status(status)
  end

  def from_payload(payload) when is_map_key(payload, "check_suite") do
    status = get_in(payload, ["check_suite", "conclusion"])
    set_color_from_status(status)
  end

  def from_payload(_payload) do
    {:error, "Unknown payload: Ignoring"}
  end

  defp set_color_from_status(status) do
    case color_from_status(status) do
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

  def color_from_status(status) do
    case Map.get(@github_state_map, status) do
      nil -> {:error, "Unknown build state: #{status}"}
      color -> {:ok, color}
    end
  end
end
