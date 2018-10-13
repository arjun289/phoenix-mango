defmodule Mango.Sales do
  @moduledoc """
  Exposes functions and utilities related to the sales.
  """

  alias Mango.Repo
  alias Mango.Sales.Order

  @cart_status "In Cart"

  @doc """
  Creates a cart, basically an `order` in `In Cart` state.
  """
  def create_cart() do
    Repo.insert!(%Order{status: @cart_status})
  end

  @doc """
  Returns a cart by the suppplied `id` if it's in the `In Cart` state.
  """
  @spec get_cart(non_neg_integer) :: Order.t() | nil
  def get_cart(id) do
    Repo.get_by(Order, id: id, status: @cart_status)
  end

  @doc """
  Updates the spplied `order` as a cart with the supplied `attrs`.

  In case the item is already present in the cart it's quantity is increased
  otherwise, a new line item is added.
  """
  @spec add_to_cart(Order.t(), map) :: {:ok, Order.t()}
    | {:error, Ecto.Changeset.t()}
  def add_to_cart(%Order{line_items: []} = cart, cart_params) do
    attrs = %{line_items: [cart_params]}
    update_cart(cart, attrs)
  end

  def add_to_cart(%Order{line_items: existing_items} = cart, cart_params) do
    new_item = %{
      product_id: String.to_integer(cart_params["product_id"]),
      quantity: String.to_integer(cart_params["quantity"])
    }

    items =
      existing_items
      |> update_if_present(new_item)

    attrs = %{line_items: items}
    update_cart(cart, attrs)
  end

  def change_cart(%Order{} = order) do
    Order.changeset(order, %{})
  end

  def update_cart(%Order{} = cart, attrs) do
    cart
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Confirms the order.

  Marks the order state as "Confirmed".
  """
  @spec confirm_order(Order.t(), map) :: {:ok, Order.t()} |
    {:error, Ecto.Changeset.t()}
  def confirm_order(%Order{} = order, params) do
    attrs = Map.put(params, "status", "Confirmed")

    order
    |> Order.checkout_changeset(attrs)
    |> Repo.update()
  end

  defp update_if_present(line_items, new_item) do
    {parsed_items, check_flag} =
      line_items
      |> Enum.reduce({[], false}, fn item, {acc, check_flag} ->
        if item.product_id == new_item.product_id do
          item = item
          |> Map.put(:quantity, item.quantity + new_item.quantity)
          |> Map.from_struct()
          acc = [item | acc]
          {acc, true}
        else
          item = Map.from_struct(item)
          acc = [item | acc]
          {acc, check_flag}
        end
      end)

    if check_flag == false do
      [new_item | parsed_items]
    else
      parsed_items
    end
  end
end
