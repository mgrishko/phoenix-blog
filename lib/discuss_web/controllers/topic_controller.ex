defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  def index(conn, _params) do
    topics = Discuss.Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic_params}) do
    changeset = Topic.changeset(%Topic{}, topic_params)

    case Discuss.Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end

    # case Topic.create_topic(topic_params) do
    #   {:ok, topic} ->
    #     conn
    #     |> put_flash(:info, "topic created successfully.")
    #     |> redirect(to: topic_path(conn, :show, topic))
    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end

  def edit(conn, %{"id" => id}) do
    topic = Discuss.Repo.get(Topic, id)
    changeset = Topic.changeset(topic, %{})
    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    # changeset = Discuss.Repo.get(Topic, id)
    #   |> Topic.changeset(topic_params)
    topic = Discuss.Repo.get(Topic, id)
    changeset = Topic.changeset(topic, topic_params)

    case Discuss.Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Discuss.Repo.get!(Topic, id)
      |> Discuss.Repo.delete!

    conn
    |> put_flash(:info, "Topic deleted.")
    |> redirect(to: topic_path(conn, :index))
  end

end
