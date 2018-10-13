defmodule Mango.Sales.Order do
  @moduledoc """
  Models an Order/Cart.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Mango.Sales.LineItem

  schema "orders" do
    # main fields
    field(:status, :string)
    field(:total, :decimal)

    # customer fields
    field :comments, :string
    field :customer_id, :integer
    field :customer_name, :string
    field :customer_email, :string
    field :residence_area, :string

    #Embeds
    embeds_many(:line_items, LineItem, on_replace: :delete)

    timestamps()
  end

  @checkout_required_fields ~w(customer_id customer_name customer_email
    residence_area )a
  @checkout_fields ~w(comments)a ++ @checkout_required_fields

  @doc false
  def changeset(%__MODULE__{} = order, attrs) do
    order
    |> cast(attrs, [:status, :total])
    |> cast_embed(:line_items, required: true, with: &LineItem.changeset/2)
    |> set_order_total()
    |> validate_required([:status, :total])
  end

  def checkout_changeset(%__MODULE__{} = order, attrs) do
    order
    |> changeset(attrs)
    |> cast(attrs, @checkout_fields)
    |> validate_required(@checkout_required_fields)
  end

  def set_order_total(%Ecto.Changeset{valid?: true} = changeset) do
    items = get_field(changeset, :line_items)
    total = Enum.reduce(items, Decimal.new(0), fn(item, acc) ->
      Decimal.add(acc, item.total)
    end)
    put_change(changeset, :total, total)
  end

  def set_order_total(changeset), do: changeset

end
