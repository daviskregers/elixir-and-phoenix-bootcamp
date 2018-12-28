defmodule Discuss.CommentsChannel do

  use Discuss.Web, :channel
  alias Discuss.Topic
  alias Discuss.Comment
  alias Discuss.User

  def join("comments:" <> topic_id, _params, socket) do

    topic_id = String.to_integer(topic_id)

    topic = Topic
    |> Repo.get(topic_id)
    |> Repo.preload(comments: [:user])

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}

  end

  def handle_in("comments:add", %{"content" => content}, socket) do

      topic = socket.assigns.topic
      user_id = socket.assigns.user_id

      changeset = topic
      |> build_assoc(:comments, user_id: user_id)
      |> Repo.preload(:user)
      |> Comment.changeset(%{content: content, user_id: user_id})

      case Repo.insert(changeset) do
        {:ok, comment} ->
          broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
          {:reply, :ok, socket}
        {:error, _reason} ->
          {:reply, {:error, %{errors: changeset}}, socket}
      end

  end

end
