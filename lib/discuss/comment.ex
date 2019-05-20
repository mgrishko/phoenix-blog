defmodule Discuss.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:content]}

  schema "comments" do
    field :content, :string
    # field :user_id, :id
    # field :topic_id, :id
    belongs_to :user,  Discuss.User
    belongs_to :topic, Discuss.Topic

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
