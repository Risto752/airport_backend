class CreateFlights < ActiveRecord::Migration[6.0]
  def change
    create_table :flights do |t|
      t.string :from
      t.string :to
      t.datetime :departure_date
      t.decimal :business_price
      t.decimal :economic_price
      t.integer :flight_duration
      t.string :stops

      t.timestamps
    end
  end
end
