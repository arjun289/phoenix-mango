defmodule Mango.CRM.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  @type t :: %__MODULE__{}

  @min 6
  @max 10

  schema "customers" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone, :string
    field :residence_area, :string

    timestamps()
  end

  @required_fields ~w(name email residence_area password)a

  @doc """
  Returns a changeset of type `%__MODULE__{}`.
  """
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: @min, max: @max)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true} = changeset) do
    password = fetch_change(changeset, :password)
    case password do
      {:ok, pw} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(pw))
      :error ->
        changeset
    end
  end

  defp put_password_hash(changeset), do: changeset
end
