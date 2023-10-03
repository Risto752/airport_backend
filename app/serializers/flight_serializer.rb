class FlightSerializer < ActiveModel::Serializer
  attributes :id, :from, :to, :departure_date, :business_price, :economic_price, :flight_duration, :stops

  def from
    Airport.find(object.from).name
  end

  def to
    Airport.find(object.to).name
  end
end