defmodule TrafficLight.Factory do
  @moduledoc false

  def build(:github_payload, %{event: "check_run", status: status}) do
    Poison.decode!(~s(
        {
          "action": "created",
          "check_run": {
            "id": 1134444775,
            "node_id": "MDg6Q2hlY2tSdW4xMTM0NDQ0Nzc1",
            "head_sha": "56ab8ff3460fdefbee3a63ed0eb7aa0b3263eea7",
            "external_id": "ca395085-040a-526b-2ce8-bdc85f692774",
            "status": "#{status}",
            "conclusion": null,
            "started_at": "2020-09-18T14:55:03Z",
            "completed_at": null
          }
        }
        ))
  end

  def build(:github_payload, %{event: "check_suite", status: status}) do
    Poison.decode!(~s(
        {
          "action": "completed",
          "check_suite": {
            "id": 1212773683,
            "node_id": "MDEwOkNoZWNrU3VpdGUxMjEyNzczNjgz",
            "head_branch": "fabrik42-patch-1",
            "head_sha": "56ab8ff3460fdefbee3a63ed0eb7aa0b3263eea7",
            "status": "completed",
            "conclusion": "#{status}",
            "before": "370c98109a22b4a81fbf27032f813bc1fcc0ffe6",
            "after": "56ab8ff3460fdefbee3a63ed0eb7aa0b3263eea7"
          }
        }
        ))
  end

  # Payload taken from https://documentation.codeship.com/general/projects/notifications/
  def build(:codeship_payload, %{status: status}) do
    Poison.decode!(~s(
          {
            "build": {
              "build_url":"https://www.codeship.com/projects/10213/builds/973711",
              "commit_url":"https://github.com/codeship/docs/
              commit/96943dc5269634c211b6fbb18896ecdcbd40a047",
              "project_id":10213,
              "build_id":973711,
              "status":"#{status}",
              "project_full_name":"codeship/docs",
              "project_name":"codeship/docs",
              "commit_id":"96943dc5269634c211b6fbb18896ecdcbd40a047",
              "short_commit_id":"96943",
              "message":"Merge pull request #34 from codeship/feature/shallow-clone",
              "committer":"beanieboi",
            "url": "https://api.github.com/repos/fabrik42/traffic-light-server-elixir/check-suites/1212773683",
              "branch":"master"
            }
          }
        ))
  end
end
