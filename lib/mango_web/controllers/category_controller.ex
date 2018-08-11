defmodule MangoWeb.CategoryController do
  use MangoWeb, :controller
  alias Mango.Catalog

  def show(conn, %{"name" => category}) do
    products = Catalog.get_category_products(category)
    render(conn, "show.html", products: products, name: category)
  end
end
