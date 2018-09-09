defmodule Mango.SalesTest do
  use Mango.DataCase

  alias Mango.{Sales, Repo}
  alias Mango.Sales.Order
  alias Mango.Catalog.Product

  test "create_cart" do
    assert %Order{status: "In Cart"} = Sales.create_cart
  end

  test "get_cart/1" do
    cart1 = Sales.create_cart()
    cart2 = Sales.get_cart(cart1.id)

    assert cart1.id == cart2.id
  end

  test "add_to_cart/2" do
    product = %Product{
      name: "Tomato",
      pack_size: "1 kg",
      price: 55,
      sku: "A123",
      is_seasonal: false, category: "vegetables" } |> Repo.insert!
    cart = Sales.create_cart()
    {:ok, cart} = Sales.add_to_cart(cart, %{"product_id" => product.id,
      "quantity" => 2})

    assert [line_item] = cart.line_items
    assert line_item.product_id == product.id
    assert line_item.product_name == product.name
    assert line_item.quantity == 2
    assert line_item.unit_price == Decimal.new(product.price)
    assert line_item.total == Decimal.mult(Decimal.new(product.price),
      Decimal.new(2))
  end

  test "add_to_cart/2 with same item inserted again" do
    product = %Product{
      name: "Tomato",
      pack_size: "1 kg",
      price: 55,
      sku: "A123",
      is_seasonal: false, category: "vegetables" } |> Repo.insert!
    cart = Sales.create_cart()
    {:ok, cart} = Sales.add_to_cart(cart, %{
      "product_id" => to_string(product.id), "quantity" => "1"})

    assert [line_item] = cart.line_items
    assert line_item.product_id == product.id
    assert line_item.product_name == product.name
    assert line_item.quantity == 1
    assert line_item.unit_price == Decimal.new(product.price)
    assert line_item.total == Decimal.mult(Decimal.new(product.price),
      Decimal.new(1))

    {:ok, cart} = Sales.add_to_cart(cart, %{
      "product_id" => to_string(product.id), "quantity" => "1"})
    assert [line_item] = cart.line_items
    assert line_item.product_id == product.id
    assert line_item.product_name == product.name
    assert line_item.quantity == 2
    assert line_item.unit_price == Decimal.new(product.price)
    assert line_item.total == Decimal.mult(Decimal.new(product.price),
      Decimal.new(line_item.quantity))
  end
end
