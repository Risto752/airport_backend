class ChangeColumnDataTypesInFlights < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE flights
      ALTER COLUMN "from" TYPE integer
      USING NULLIF("from", '')::integer
    SQL

    execute <<-SQL
      ALTER TABLE flights
      ALTER COLUMN "to" TYPE integer
      USING NULLIF("to", '')::integer
    SQL
  end

  def down
    change_column :flights, :from, :string
    change_column :flights, :to, :string
  end
end
