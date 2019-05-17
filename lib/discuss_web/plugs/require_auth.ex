defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias DiscussWeb.Router.Helpers
  # alias Discuss.User
  # alias Discuss.Repo

  def init(_default) do
  end

  def call(conn, _default) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "Please, sign in")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt()
    end
  end


end