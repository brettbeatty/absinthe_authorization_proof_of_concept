defmodule Scv.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Supervisor.start_link([Scv.Web], strategy: :one_for_one, name: Scv.Supervisor)
  end
end
