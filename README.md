# Scv

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `scv` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scv, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/scv](https://hexdocs.pm/scv).

## Example Query

To `http://localhost:27388`

```graphql
query UsersWithNotes {
  users(count: 5) {
    id
    name
    email
    notes(count: 3) {
      id
      value
      author {
        id
        name
        email
      }
    }
  }
}
```
