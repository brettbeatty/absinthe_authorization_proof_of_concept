defmodule Scv.Web do
  use Plug.Builder

  def child_spec(_opts) do
    Plug.Cowboy.child_spec(scheme: :http, plug: __MODULE__, options: [port: 27388])
  end

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    json_decoder: Jason
  )

  plug(Absinthe.Plug, schema: Scv.Schema)
end
