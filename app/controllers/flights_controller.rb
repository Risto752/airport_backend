class FlightsController < ApplicationController
  def index
    query = Flight.all

    permitted_params = params.permit(:company_id, :stops, :from, :to, :select_sort_state, :sort_toggle,
      :business_min, :business_max, :economic_min, :economic_max)

    if permitted_params.present?
      query = query.where(company_id: permitted_params[:company_id]) if permitted_params[:company_id].present?
      query = query.where(stops: permitted_params[:stops]) if permitted_params[:stops].present?

      query = query.joins("LEFT JOIN airports AS from_airport ON flights.from = from_airport.id")
            .where('from_airport.name LIKE ?', "%#{permitted_params[:from]}%") if permitted_params[:from].present?

      query = query.joins("LEFT JOIN airports AS to_airport ON flights.to = to_airport.id")
            .where('to_airport.name LIKE ?', "%#{permitted_params[:to]}%") if permitted_params[:to].present?

      if permitted_params[:select_sort_state].present? && permitted_params[:sort_toggle].present?
        column_name = case permitted_params[:select_sort_state]
                      when 'cheapest_business'
                        'business_price'
                      when 'cheapest_economic'
                        'economic_price'
                      when 'fastest'
                        'flight_duration'
                      else
                        nil
                    end

        if column_name
          direction = permitted_params[:sort_toggle] == 'asc' ? 'asc' : 'desc'
          query = query.order("#{column_name} #{direction}")
        end
      end

      query = query.where('flights.business_price >= ? AND flights.business_price <= ?', 
                          permitted_params[:business_min], permitted_params[:business_max])

      query = query.where('flights.economic_price >= ? AND flights.economic_price <= ?', 
                          permitted_params[:economic_min], permitted_params[:economic_max])

      @flights = query.all
      render json: @flights, each_serializer: FlightSerializer

      
    else
      @flights = Flight.all
    render json: @flights, each_serializer: FlightSerializer
    end
  end
end
