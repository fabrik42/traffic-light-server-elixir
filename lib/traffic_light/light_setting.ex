defmodule TrafficLight.LightSetting do
  alias TrafficLight.LightSetting.Server

  defstruct mode: nil, red: nil, yellow: nil, green: nil

  @colors [:red, :yellow, :green]

  def build do
    %__MODULE__{mode: current_mode(), red: false, yellow: false, green: false}
  end

  def ordered_colors do
    @colors
  end

  def current_mode do
    Application.get_env(:traffic_light, :light_mode)
  end

  def website_update_allowed? do
    current_mode() == "public"
  end

  def subscribe() do
    Server.subscribe()
  end

  def save(light_setting, light_mode \\ current_mode()) do
    Server.set(light_mode, light_setting)
  end

  def load(light_mode \\ current_mode()) do
    Server.get(light_mode)
  end

  def from_json(nil), do: nil

  def from_json(light_setting) do
    Poison.decode!(light_setting, as: %__MODULE__{}, keys: :atoms!)
  end

  def as_json(light_setting) do
    %{
      mode: light_setting.mode,
      red: light_setting.red,
      yellow: light_setting.yellow,
      green: light_setting.green
    }
  end

  def to_json(light_setting) do
    light_setting |> as_json |> Poison.encode!()
  end

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
