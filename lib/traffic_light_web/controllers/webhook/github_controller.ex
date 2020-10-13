defmodule TrafficLightWeb.Webhook.GithubController do
  use TrafficLightWeb, :controller

  alias TrafficLight.LightSetting
  alias TrafficLight.LightSetting.WebhookParser.Github

  def create(conn, _params) do
    with {:ok, light_setting} <- Github.from_payload(conn.body_params),
         {:ok, _result} <- LightSetting.save(light_setting, "ci") do
      conn
      |> put_status(201)
      |> json(%{success: true})
    else
      {:error, error} ->
        conn
        |> put_status(422)
        |> json(%{success: false, error: error})
    end
  end
end
