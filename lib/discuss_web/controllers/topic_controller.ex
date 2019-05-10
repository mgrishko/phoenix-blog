defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  def new(conn, params) do
    # topic = %Topic{}
    # params = %{}
    # changeset = %Topic.changeset(topic, params)
    changeset = %Topic.changeset(%Topic{}, %{})
  end
end
