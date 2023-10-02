class AddForeignKeysToFlights < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :flights, :airports, column: :from, primary_key: :id
    add_foreign_key :flights, :airports, column: :to, primary_key: :id
  end
end
