class AddCompanyRefToFlights < ActiveRecord::Migration[6.0]
  def change
    add_reference :flights, :company, foreign_key: true
  end
end
