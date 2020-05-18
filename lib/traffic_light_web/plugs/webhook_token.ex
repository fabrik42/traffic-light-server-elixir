defmodule TrafficLightWeb.Plugs.WebhookToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    expected_token = Keyword.fetch!(opts, :token)
    given_token = parse_webhook_token(conn)

    if Plug.Crypto.secure_compare(expected_token, given_token) do
      conn
    else
      conn
      |> resp(401, "Unauthorized")
      |> halt()
    end
  end

  defp parse_webhook_token(conn) do
    conn = fetch_query_params(conn)
    params = conn.query_params
    params["token"] || ""
  end
end
