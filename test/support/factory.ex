defmodule TrafficLight.Factory do
  @moduledoc false

  def build(:github_payload, %{status: status}) do
    Poison.decode!(~s(
        {
          "id": 6805126730,
          "sha": "6113728f27ae82c7b1a177c8d03f9e96e0adf246",
          "name": "Codertocat/Hello-World",
          "target_url": null,
          "context": "default",
          "description": null,
          "state": "#{status}"
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
