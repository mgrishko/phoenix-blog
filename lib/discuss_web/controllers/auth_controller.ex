defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.Accounts.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: Atom.to_string(auth.provider)}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
    # below for update user timestams and token
    # result =
    #   case  Discuss.Repo.get_by(User, email: user_params.email) do
    #     nil  -> %User{email: user_params.email, token: user_params.token, provider: Atom.to_string(auth.provider)} # User not found, we build one
    #     user -> user    # User exists, let's use it
    #   end
    #   |> User.changeset(user_params)
    #   |> Discuss.Repo.insert_or_update

    # case result do
    #   {:ok, struct} -> # Inserted or updated with success
    #     conn
    #     |> put_flash(:info, "Welcome back!")
    #     |> put_session(:user_id, struct.id)
    #     |> redirect(to: topic_path(conn, :index ))
    #   {:error, changeset} -> # Something went wrong
    #     conn
    #     |> put_flash(:error, "Error signing in")
    #     |> redirect(to: topic_path(conn, :index))
    # end
  end

  def signout(conn, _params) do
    conn
    # |> configure_session(drop: true)
    |> put_session(:user_id, nil)
    |> redirect(to: topic_path(conn, :index))
  end


  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index ))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end
  defp insert_or_update_user(changeset) do
    case  Discuss.Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Discuss.Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

end