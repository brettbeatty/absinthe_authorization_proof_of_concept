defmodule Scv.Authorization do
  @behaviour Absinthe.Middleware
  @behaviour Absinthe.Plugin

  @impl Absinthe.Middleware
  def call(res, permissions)

  def call(res = %{state: :unresolved}, permissions) do
    permissions = List.wrap(permissions)
    permission_set = MapSet.new(permissions)

    res.acc[__MODULE__].keys
    |> update_in(&MapSet.union(&1, permission_set))
    |> Map.update!(:middleware, &[{__MODULE__, permissions} | &1])
    |> Map.put(:state, :suspended)
  end

  def call(res = %{state: :suspended}, permissions) do
    requested = Map.take(res.acc[__MODULE__].result, permissions)
    context = Map.put(res.context, :permissions, requested)
    %{res | context: context, state: :unresolved}
  end

  @impl Absinthe.Plugin
  def before_resolution(exec) do
    case exec.acc do
      %{__MODULE__ => _} ->
        put_in(exec.acc[__MODULE__].keys, MapSet.new())

      _ ->
        put_in(exec.acc[__MODULE__], %{keys: MapSet.new(), result: nil})
    end
  end

  @impl Absinthe.Plugin
  def after_resolution(exec) do
    permissions =
      exec.acc[__MODULE__].keys
      |> Enum.to_list()
      |> check_permissions()

    put_in(exec.acc[__MODULE__].result, permissions)
  end

  defp check_permissions([]), do: %{}

  defp check_permissions(keys) do
    IO.inspect({:check_permissions, keys})
    Map.new(keys, &{&1, true})
  end

  @impl Absinthe.Plugin
  def pipeline(pipeline, exec) do
    if Enum.empty?(exec.acc[__MODULE__].keys) do
      pipeline
    else
      [Absinthe.Phase.Document.Execution.Resolution | pipeline]
    end
  end
end
