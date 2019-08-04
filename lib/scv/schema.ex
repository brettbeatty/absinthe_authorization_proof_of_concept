defmodule Scv.Schema do
  use Absinthe.Schema

  query do
    field :users, list_of(:user) do
      arg(:count, non_null(:integer))
      resolve(&users/2)
    end
  end

  object :user do
    field(:id, :id)
    field(:name, :string)

    field :notes, list_of(:note) do
      arg(:count, non_null(:integer))
      resolve(&notes/3)
    end
  end

  object :note do
    field(:id, :id)
    field(:value, :string)
    field(:author, :user)
  end

  defp users(args, _info) do
    {:ok, Enum.map(1..args.count, &user/1)}
  end

  defp user(id) do
    %{id: id, name: "User #{id}"}
  end

  defp notes(user, args, _info) do
    {:ok, Enum.map(1..args.count, &note(&1, user))}
  end

  defp note(id, author) do
    %{id: id, value: "Note #{id}", author: author}
  end
end
