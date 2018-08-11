defmodule Mango.Factory do

  alias Mango.Repo
  alias Mango.Catalog.Product

  def products(_context) do
    Repo.insert(%Product{name: "Apple", price: 100, is_seasonal: true,
    category: "fruits"})
    Repo.insert(%Product{name: "Tomato", price: 50, is_seasonal: false,
    category: "vegetables"})
  :ok
  end
end
