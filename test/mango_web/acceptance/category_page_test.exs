defmodule MangoWeb.CategoryPageTest do
  use Mango.DataCase
  use Hound.Helpers
  import Hound.Helpers.Page
  import Mango.Factory

  hound_session()

  ## Given
  # Two products apple and tomato categorized
  # under `fruits` and `vegetable` respectively.
  setup :products

  test "show fruits" do
    # navigate to fruits page
    navigate_to("/categories/fruits")

    # Then
    # I expect the page title to be "Fruits"
    page_title = :css |> find_element( ".page-title") |> visible_text()
    assert page_title == "Fruits"

    # I expect `Apple` and it's price
    product_name = :css |> find_element(".product-name") |> visible_text()
    product_price = :css |> find_element(".product-price") |> visible_text()

    assert product_name == "Apple"
    assert product_price == "INR 100"

    # The page shouldn't have `Tomato`.
    refute page_source() =~ "Tomato"
  end

  test "show vegetables" do
     # navigate to vegetables page
     navigate_to("/categories/vegetables")

     # Then
     # I expect the page title to be "Vegetables"
     page_title = :css |> find_element( ".page-title") |> visible_text()
     assert page_title == "Vegetables"

     # I expect Tomato and it's price
     product_name = :css |> find_element(".product-name") |> visible_text()
     product_price = :css |> find_element(".product-price") |> visible_text()

     assert product_name == "Tomato"
     assert product_price == "INR 50"

     # The page shouldn't have apple
     refute page_source() =~ "Apple"
  end
end
