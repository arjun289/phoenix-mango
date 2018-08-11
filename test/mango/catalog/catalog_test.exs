defmodule Mango.CatalogTest do
  use Mango.DataCase
  alias Mango.Catalog
  alias Mango.Catalog.Product
  import Mango.Factory

  setup :products

  test "list_products/0 returns all products" do
    [p1 = %Product{}, p2 = %Product{}] = Catalog.list_products()

    assert p1.name == "Apple"
    assert p2.name == "Tomato"
  end

  test "list_seasonal_products/0 return all seasonal products" do
    [product = %Product{}] = Catalog.list_seasonal_products()

    assert product.name == "Apple"
  end

  test "get_category_products/1 returns products of given category" do
    [product = %Product{}] = Catalog.get_category_products("fruits")

    assert product.name == "Apple"
  end
end
