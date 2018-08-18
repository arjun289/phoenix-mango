defmodule MangoWeb.RegistrationController do
  use MangoWeb, :controller

  alias Auroville.ResidenceService
  alias Mango.CRM

  def new(conn, _) do
    residence_areas = ResidenceService.list_areas()
    changeset = CRM.build_customer()
    render conn, "new.html", changeset: changeset,
      residence_areas: residence_areas
  end

  def create(conn, %{"registration" => registration_params}) do
    case CRM.create_customer(registration_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Registration Successful")
        |> redirect(to: page_path(conn, :index))
        {:error, changeset} ->
        residence_areas = ResidenceService.list_areas()
        render(conn, "new.html", changeset: changeset,
          residence_areas: residence_areas)
    end
  end
end
