class Flight < ApplicationRecord
  belongs_to :company
  belongs_to :from_airport, class_name: 'Airport', foreign_key: 'from'
  belongs_to :to_airport, class_name: 'Airport', foreign_key: 'to'
end
