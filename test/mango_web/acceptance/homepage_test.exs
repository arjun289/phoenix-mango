defmodule Mango.HomePageTest do
  use Mango.DataCase
  use Hound.Helpers
  import Hound.Helpers.Page
  import Mango.Factory

  hound_session()
  setup :products

  test "presence of seasonal products" do
    # Given #
    # There are two products apple and tomato,
    # with only apple being the seasonal product

    # When I navigate to homepage.
    navigate_to("/")
    page_title = find_element(:css, ".page-title")

    # I expect title to be "Seasonal products"
    assert visible_text(page_title) == "Seasonal products"

    # And I expect only the seasonal product apple to be
    # displayed
    product = find_element(:css, ".product")
    product_name =
      product
      |> find_within_element(:css, ".product-name")
      |> visible_text()

      product_price =
        product
      |> find_within_element(:css, ".product-price")
      |> visible_text()

    assert product_name == "Apple"
    assert product_price == "100"

    # Also I don't expect to find tomato on that page
    refute page_source() =~ "Tomato"
  end

end
