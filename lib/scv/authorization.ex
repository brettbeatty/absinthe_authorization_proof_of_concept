defmodule Scv.Authorization do
  @behaviour Absinthe.Middleware
  @behaviour Absinthe.Plugin

  @impl Absinthe.Middleware
  def call(res, permissions)

  def call(res = %{state: :unresolved}, permissions) do
    permissions = List.wrap(permissions)
    permission_map = Map.new(permissions, &{&1, nil})
    acc = Map.update(res.acc, __MODULE__, permission_map, &Map.merge(&1, permission_map))
    middleware = [{__MODULE__, permissions} | res.middleware]
    %{res | acc: acc, state: :suspended, middleware: middleware}
  end

  def call(res = %{state: :suspended}, permissions) do
    requested = Map.take(res.acc[__MODULE__], permissions)
    IO.inspect({requested, permissions})
    acc = Map.put(res.acc, :context, requested)
    %{res | acc: acc, state: :unresolved}
  end

  @impl Absinthe.Plugin
  def before_resolution(exec) do
    put_in(exec.acc[__MODULE__], %{})
  end

  @impl Absinthe.Plugin
  def after_resolution(exec) do
    permissions =
      exec.acc[__MODULE__]
      |> Map.keys()
      |> check_permissions()

    put_in(exec.acc[__MODULE__], permissions)
  end

  defp check_permissions([]), do: %{}

  defp check_permissions(keys) do
    IO.inspect({:check_permissions, keys})
    Map.new(keys, &{&1, true})
  end

  @impl Absinthe.Plugin
  def pipeline(pipeline, exec) do
    if Enum.empty?(exec.acc[__MODULE__]) do
      pipeline
    else
      [Absinthe.Phase.Document.Execution.Resolution | pipeline]
    end
  end
end
