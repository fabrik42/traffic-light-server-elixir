defmodule TrafficLight.LightSetting do
  defstruct mode: nil, red: nil, yellow: nil, green: nil

  def current_mode do
    "ci"
  end

  def from_json(nil), do: nil

  def from_json(light_setting) do
    Poison.decode!(light_setting, as: %__MODULE__{}, keys: :atoms!)
  end

  def to_json(light_setting) do
    Poison.encode!(light_setting, only: [:mode, :red, :yello, :green])
  end
end
