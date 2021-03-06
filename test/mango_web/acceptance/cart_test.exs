defmodule MangoWeb.Acceptance.CartTest do
  use Mango.DataCase
  use Hound.Helpers

  hound_session()

  setup do
    alias Mango.Repo
    alias Mango.Catalog.Product

    # setup products
    Repo.insert(%Product{ name: "Carrot", pack_size: "1 kg",
      price: 55, sku: "A123", is_seasonal: true })

    Repo.insert(%Product{ name: "Apple", pack_size: "1 kg", price: 75,
      sku: "B232", is_seasonal: true })
    :ok
  end

  test "presence of cart form for each product" do
    navigate_to("/")

    products = find_all_elements(:css, ".product")

    assert Enum.count(products) != 0
    products
    |> Enum.each(fn product ->
      button = find_within_element(product, :tag, "button")
      assert visible_text(button) == "Add to Cart"
    end)
  end

  test "add to cart" do
    navigate_to("/")

    [product | _rest] = find_all_elements(:css, ".product")

    product_name =
      product
      |> find_within_element(:name, "cart[product_name]")
      |> attribute_value("value")

      pack_size =
        product
        |> find_within_element(:name, "cart[pack_size]")
        |> attribute_value("value")

      find_within_element(product, :name, "cart[quantity]")
      |> fill_field(2)

      find_within_element(product, :tag, "button")
      |> click()

      message = "Product added to cart - #{product_name}(#{pack_size}) x 2 qty"
      assert(String.contains? visible_page_text(), message) #{pack_size}) X 2 qty"
    end
end
