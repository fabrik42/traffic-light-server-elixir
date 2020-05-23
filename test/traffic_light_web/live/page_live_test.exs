defmodule TrafficLightWeb.PageLiveTest do
  use TrafficLightWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TrafficLight.LightSetting

  setup do
    {:ok, _} = LightSetting.save(LightSetting.build(mode: "ci"), "ci")
    {:ok, _} = LightSetting.save(LightSetting.build(mode: "public"), "public")
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

  test "updating the light switches", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")

    # do not use the returned html right away, because we wait for the
    # broadcast of the light setting server
    render_click(page_live, :set_color, %{"color" => "red", "new-state" => "on"})

    {:ok, page_live, _disconnected_html} = live(conn, "/")

    assert page_live
           |> element(~s(a[data-color="red"]))
           |> render() =~ ~s(<a href="#" data-state="on" data-color="red")

    assert page_live
           |> element(~s(a[data-color="yellow"]))
           |> render() =~ ~s(<a href="#" data-state="off" data-color="yellow")

    assert page_live
           |> element(~s(a[data-color="green"]))
           |> render() =~ ~s(<a href="#" data-state="off" data-color="green")
  end

  # This test requires some implicit knowledge (the logic in LightSetting.website_update_allowed?)
  # because we are still lacking a better solution (like a mocking lib).
  test "do not allow updating the light switches for ci mode", %{conn: conn} do
    org_mode = Application.get_env(:traffic_light, :light_mode)
    Application.put_env(:traffic_light, :light_mode, "ci")

    {:ok, light_setting_before} = LightSetting.load()

    {:ok, page_live, _disconnected_html} = live(conn, "/")

    render_click(page_live, :set_color, %{"color" => "red", "new-state" => "on"})

    # Persisted setting did not change
    {:ok, light_setting_after} = LightSetting.load()
    assert light_setting_before == light_setting_after

    # View did not change
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

    # Restore global light mode setting
    Application.put_env(:traffic_light, :light_mode, org_mode)
  end
end
