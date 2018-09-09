defmodule Mango.Sales.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mango.Sales.LineItem

  schema "orders" do
    field :status, :string
    field :total, :decimal
    embeds_many(:line_items, LineItem, on_replace: :delete)
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = order, attrs) do
    order
    |> cast(attrs, [:status, :total])
    |> cast_embed(:line_items, required: true, with: &LineItem.changeset/2)
    |> set_order_total()
    |> validate_required([:status, :total])
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
