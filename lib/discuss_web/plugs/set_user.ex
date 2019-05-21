defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn

  alias Discuss.Accounts.User
  alias Discuss.Repo

  def init(_default) do
  end

  def call(conn, _default) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      true ->
        assign(conn, :user, nil)
    end
  end


end