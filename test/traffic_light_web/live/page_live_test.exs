defmodule TrafficLightWeb.PageLiveTest do
  use TrafficLightWeb.ConnCase

  import Phoenix.LiveViewTest

  setup do
    ls = TrafficLight.LightSetting.build()
    {:ok, _} = TrafficLight.LightSetting.save(ls)
    :ok
  end

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ ~s(<ul id="switch">)
    assert render(page_live) =~ ~s(<ul id="switch">)
  end

  test "rendering the light switches", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")

    assert page_live
           |> element(~s(a[data-color="red"]))
           |> render() =~ ~s(<a href="#" data-state="off" data-color="red")

    assert page_live
           |> element(~s(a[data-color="yellow"]))
           |> render() =~ ~s(<a href="#" data-state="off" data-color="yellow")

    assert page_live
           |> element(~s(a[data-color="green"]))
           |> render() =~ ~s(<a href="#" data-state="off" data-color="green")
  end
end
