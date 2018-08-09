defmodule MangoWeb.CategoryController do
  use MangoWeb, :controller
  alias Mango.Catalog

  def show(conn, _params) do
    products = Catalog.list_products()
    render(conn, "show.html", products: products, name: "Title")
  end
end
