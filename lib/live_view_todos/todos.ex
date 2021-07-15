defmodule LiveViewTodos.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias LiveViewTodos.Repo

  alias LiveViewTodos.Todos.Todo

  @topic inspect(__MODULE__)
  def subscribe do
    Phoenix.PubSub.subscribe(LiveViewTodos.PubSub, @topic)
  end

  def broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(LiveViewTodos.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  def list_todos do
    Repo.all(Todo)
  end

  def get_todo!(id), do: Repo.get!(Todo, id)

  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:todo, :created])
  end

  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:todo, :updated])
  end

  def delete_todo(%Todo{} = todo) do
    todo
    |> Repo.delete()
    |> broadcast_change([:todo, :deleted])
  end

  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
