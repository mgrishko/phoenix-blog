defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    topics = Discuss.Repo.all(Topic)

    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic_params}) do
    changeset = conn.assigns.user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(topic_params)

    case Discuss.Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Discuss.Repo.get!(Topic, id)
    render(conn, "show.html", topic: topic)
  end

  def edit(conn, %{"id" => id}) do
    topic = Discuss.Repo.get(Topic, id)
    changeset = Topic.changeset(topic, %{})

    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
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


  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn # params diff than on edit, update, delete butsends id too

    if Discuss.Repo.get(Topic, topic_id) == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that topic")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end

end
