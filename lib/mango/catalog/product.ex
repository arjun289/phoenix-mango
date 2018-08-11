defmodule Mango.Catalog.Product do
  @moduledoc """
  Models a product
  """
  use Ecto.Schema

  @type t :: %__MODULE__{}


  schema "products" do
    field(:image, :string)
    field(:name, :string)
    field(:is_seasonal, :boolean, default: false)
    field(:price, :decimal)
    field(:sku, :string)
    field(:category, :string)
    field(:pack_size, :string)

    timestamps()
  end

end

