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
      middleware(Scv.Authorization, [:note_author?, :users?])
      resolve(&author/3)
    end
  end

  @impl Absinthe.Schema
  def plugins do
    [Scv.Authorization | Absinthe.Plugin.defaults()]
  end

  defp users(args, res) do
    if res.context.permissions.users? do
      {:ok, Enum.map(1..args.count, &user/1)}
    else
      {:error, "Not authorized to list users"}
    end
  end

  defp user(id) do
    %{id: id, name: "User #{id}", email: "user#{id}@example.com"}
  end

  defp email(user, _args, res) do
    if res.context.permissions.user_email? do
      {:ok, user.email}
    else
      {:error, "Not authorized to get user emails"}
    end
  end

  defp notes(user, args, res) do
    if res.context.permissions.user_notes? do
      {:ok, Enum.map(1..args.count, &note(&1, user))}
    else
      {:error, "Not authorized to get user notes"}
    end
  end

  defp note(id, author) do
    %{id: id, value: "Note #{id}", author: author}
  end

  defp author(note, _args, res) do
    if res.context.permissions.note_author? and res.context.permissions.users? do
      {:ok, note.author}
    else
      {:error, "Not authorized to get note author"}
    end
  end
end
