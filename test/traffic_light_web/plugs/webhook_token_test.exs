defmodule TrafficLightWeb.Plugs.WebhookTokenTest do
  use TrafficLightWeb.ConnCase

  alias TrafficLightWeb.Plugs.WebhookToken

  def prepare_conn(conn) do
    conn
    |> bypass_through(TrafficLightWeb.Router, :webhooks)
  end

  test "without token" do
    token = "CORRECT_TOKEN"

    conn =
      build_conn(:post, "/webhooks/codeship")
      |> prepare_conn
      |> WebhookToken.call(token: token)

    assert conn.halted
  end

  test "with wrong token" do
    token = "CORRECT_TOKEN"

    conn =
      build_conn(:post, "/webhooks/codeship?token=WRONG_TOKEN")
      |> prepare_conn
      |> WebhookToken.call(token: token)

    assert conn.halted
  end

  test "with correct token" do
    token = "CORRECT_TOKEN"

    conn =
      build_conn(:post, "/webhooks/codeship?token=#{token}")
      |> prepare_conn
      |> WebhookToken.call(token: token)

    refute conn.halted
  end
end
