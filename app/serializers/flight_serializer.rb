class FlightSerializer < ActiveModel::Serializer
  attributes :id, :from, :to, :departure_date, :business_price, :economic_price, :flight_duration, :stops,:from_id, :to_id, :company_id

  def from
    Airport.find(object.from).name
  end

  def to
    Airport.find(object.to).name
  end

  def from_id
    object.from
  end

  def to_id
    object.to
  end

  def company_id
    object.company_id
  end

end