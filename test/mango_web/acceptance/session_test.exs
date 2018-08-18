defmodule MangoWeb.Acceptance.SessionTest do
  use Mango.DataCase
  use Hound.Helpers

  hound_session()

  setup do
    ## Given ##
    # There is a valid registered user

    alias Mango.CRM

    valid_attrs = %{
      "name" => "John",
      "email" => "john@example.com",
      "password" => "secret",
      "residence_area" => "Area 1",
      "phone" => "1111"
    }

    {:ok, _} = CRM.create_customer(valid_attrs)
    :ok
  end

end
