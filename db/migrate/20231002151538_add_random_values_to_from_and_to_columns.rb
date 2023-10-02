class AddRandomValuesToFromAndToColumns < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      UPDATE flights
      SET "from" = floor(random() * (102 - 3 + 1) + 3)::integer,
          "to" = floor(random() * (102 - 3 + 1) + 3)::integer;
    SQL
  end

  def down
    execute <<-SQL
      UPDATE flights
      SET "from" = NULL,
          "to" = NULL;
    SQL
  end
end
