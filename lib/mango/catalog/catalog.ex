defmodule Mango.Catalog do
  @moduledoc false
  alias Mango.Catalog.Product
  alias Mango.Repo

  def list_products do
    Repo.all(Product)
  end

  def list_seasonal_products do
    list_products()
    |> Enum.filter(fn(product) ->
      product.is_seasonal == true
    end)
  end

  def get_category_products(category) do
    products = list_products()
    Enum.filter(products, fn(product) ->
      product.category == category
    end)
  end
end
