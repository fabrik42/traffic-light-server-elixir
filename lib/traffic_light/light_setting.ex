defmodule TrafficLight.LightSetting do
  defstruct mode: nil, red: nil, yellow: nil, green: nil

  @colors [:red, :yellow, :green]

  def ordered_colors do
    @colors
  end

  def current_mode do
    "ci"
  end

  def from_json(nil), do: nil

  def from_json(light_setting) do
    Poison.decode!(light_setting, as: %__MODULE__{}, keys: :atoms!)
  end

  def to_json(light_setting) do
    Poison.encode!(light_setting, only: [:mode | ordered_colors()])
  end

  def switch_value(light_setting, color) do
    value = Map.get(light_setting, color)
    if value, do: "on", else: "off"
  end

  def opposite_switch_value(light_setting, color) do
    value = switch_value(light_setting, color)
    if value == "off", do: "on", else: "off"
  end

  def top_bar_class_name(%{red: true, yellow: false, green: false}), do: "red"
  def top_bar_class_name(%{red: false, yellow: true, green: false}), do: "yellow"
  def top_bar_class_name(%{red: false, yellow: false, green: true}), do: "green"
  def top_bar_class_name(_light_setting), do: ""

  def update_color(light_setting, color, new_state) do
    value = if new_state == "on", do: true, else: false

    is_valid_color =
      ordered_colors()
      |> Enum.map(&Atom.to_string/1)
      |> Enum.member?(color)

    case is_valid_color do
      true ->
        {:ok, Map.put(light_setting, String.to_atom(color), value)}

      false ->
        {:error, "Invalid data given! color: #{color}, state: #{new_state}"}
    end
  end
end
