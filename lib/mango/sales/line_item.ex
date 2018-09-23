defmodule Mango.Sales.LineItem do
  @moduledoc """
  Models a LineItem
  """

  use Ecto.Schema

  import Ecto.Changeset
  alias Mango.Catalog

  @type t :: %__MODULE__{}

  embedded_schema do
    field(:product_id, :integer)
    field(:product_name, :string)
    field(:pack_size, :string)
    field(:quantity, :integer)
    field(:unit_price, :decimal)
    field(:total, :decimal)
    field(:delete, :boolean, virutal: true)
  end

  @cast_params ~w(product_id product_name pack_size quantity unit_price total
    delete)a
  @required_params ~w(product_id product_name pack_size quantity unit_price)a

  def changeset(%__MODULE__{} = line_item, attrs) do
    line_item
    |> cast(attrs, @cast_params)
    |> set_delete()
    |> set_product_details()
    |> set_total()
    |> validate_required(@required_params)
  end

  defp set_product_details(%Ecto.Changeset{valid?: true} = changeset) do
    case get_change(changeset, :product_id) do
      nil ->
        changeset
      product_id ->
        product = Catalog.get_product!(product_id)
        changeset
        |> put_change(:product_name, product.name)
        |> put_change(:unit_price, product.price)
        |> put_change(:pack_size, product.pack_size)
    end
  end

  defp set_product_details(changeset), do: changeset

  defp set_total(%Ecto.Changeset{valid?: true} = changeset) do
    quantity =
      changeset
      |> get_field(:quantity)
      |> Decimal.new()

    unit_price = get_field(changeset, :unit_price)

    put_change(changeset, :total, Decimal.mult(unit_price, quantity))
  end
  defp set_total(changeset), do: changeset

  defp set_delete(%Ecto.Changeset{} = changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end

end
