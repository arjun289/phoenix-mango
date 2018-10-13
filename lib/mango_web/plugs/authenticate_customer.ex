defmodule MangoWeb.Plugs.AuthenticateCustomer do

  @moduledoc """
  Plug to check authenticated users.

  Checks if the user is present in the `conn` struct, if found user is
  authenticated otherwise, redirected to the login page.
  """

  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  def init(_opts), do: nil

  def call(conn, _params) do
    case conn.assigns[:current_customer] do
      nil ->
        conn
        |> put_session(:intending_to_visit, conn.request_path)
        |> put_flash(:info, "You must be signed in")
        |> redirect(to: "/login")
        |> halt()
      _ ->
        conn
    end
  end

end
