defmodule Mango.CRM do
  @moduledoc """
  Functions and Utilities for CRM.
  """

  alias Mango.CRM.Customer
  alias Mango.Repo
  alias Comeonin.Bcrypt

  def build_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
  end

  def create_customer(attrs) do
    attrs
    |> build_customer()
    |> Repo.insert()
  end

  def get_customer(id) do
    Repo.get(Customer, id)
  end

  def get_customer_by_email(email) do
    Repo.get_by(Customer, email: email)
  end

  def get_customer_by_credentials(%{"email" => email, "password" => password}) do
    customer = get_customer_by_email(email)

    cond do
      customer && Bcrypt.checkpw(password, customer.password_hash) ->
        customer
      true ->
        :error
    end
  end
end
