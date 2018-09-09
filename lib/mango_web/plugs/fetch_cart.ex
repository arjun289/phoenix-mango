defmodule MangoWeb.Plugs.FetchCart do
  @moduledoc """
  Plug to fetch current __cart__ which is basically an `order` in the `In Cart`
  state.

  If a `:cart_id` is already present in the session then put the `order`
  for the same in `assigns` `map` under the `:cart` key.
  Otherwise, put a new order with cart state in the assigns and update the
  `:cart_id` key in session with the `id` of the new `order`.
  """

  import Plug.Conn
  alias Mango.Sales
  alias Mango.Sales.Order

  def init(_opts), do: nil

  def call(conn, _) do
    with cart_id <- get_session(conn, :cart_id),
      true <- is_integer(cart_id),
      %Order{} = cart <- Sales.get_cart(cart_id) do
        assign(conn, :cart, cart)
    else
      _ ->
        cart = Sales.create_cart()
        conn
        |> put_session(:cart_id, cart.id)
        |> assign(:cart, cart)
    end
  end

end
