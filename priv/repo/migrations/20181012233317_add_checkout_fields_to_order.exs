defmodule Mango.Repo.Migrations.AddCheckoutFieldsToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add(:comments, :text)
      add(:customer_id, references(:customers))
      add(:customer_name, :string)
      add(:customer_email, :string)
      add(:residence_area, :string)
    end
  end
end
