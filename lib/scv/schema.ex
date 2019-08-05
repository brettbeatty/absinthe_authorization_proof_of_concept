defmodule Scv.Schema do
  use Absinthe.Schema

  query do
    field :users, list_of(:user) do
      arg(:count, non_null(:integer))
      middleware(Scv.Authorization, :users?)
      resolve(&users/2)
    end
  end

  object :user do
    field(:id, :id)
    field(:name, :string)

    field :email, :string do
      middleware(Scv.Authorization, :user_email?)
      resolve(&email/3)
    end

    field :notes, list_of(:note) do
      arg(:count, non_null(:integer))
      middleware(Scv.Authorization, :user_notes?)
      resolve(&notes/3)
    end
  end

  object :note do
    field(:id, :id)
    field(:value, :string)

    field :author, :user do
      middleware(Scv.Authorization, :note_author?)
      resolve(&author/3)
    end
  end

  @impl Absinthe.Schema
  def plugins do
    [Scv.Authorization | Absinthe.Plugin.defaults()]
  end

  defp users(args, _info) do
    {:ok, Enum.map(1..args.count, &user/1)}
  end

  defp user(id) do
    %{id: id, name: "User #{id}", email: "user#{id}@example.com"}
  end

  defp email(user, _args, _info) do
    {:ok, user.email}
  end

  defp notes(user, args, _info) do
    {:ok, Enum.map(1..args.count, &note(&1, user))}
  end

  defp note(id, author) do
    %{id: id, value: "Note #{id}", author: author}
  end

  defp author(note, _args, _info) do
    {:ok, note.author}
  end
end
