class FlightsController < ApplicationController
  def index
    query = Flight.all

    permitted_params = params.permit(:company_id, :stops, :from, :to, :select_sort_state, :sort_toggle,
                                     :business_min, :business_max, :economic_min, :economic_max)

    if permitted_params.present?
      query = query.where(company_id: permitted_params[:company_id]) if permitted_params[:company_id].present?
      query = query.where(stops: permitted_params[:stops]) if permitted_params[:stops].present?

      if permitted_params[:from].present?
        query = query.joins('LEFT JOIN airports AS from_airport ON flights.from = from_airport.id')
                     .where('from_airport.name LIKE ?', "%#{permitted_params[:from]}%")
      end

      if permitted_params[:to].present?
        query = query.joins('LEFT JOIN airports AS to_airport ON flights.to = to_airport.id')
                     .where('to_airport.name LIKE ?', "%#{permitted_params[:to]}%")
      end

      if permitted_params[:select_sort_state].present? && permitted_params[:sort_toggle].present?
        column_name = case permitted_params[:select_sort_state]
                      when 'cheapest_business'
                        'business_price'
                      when 'cheapest_economic'
                        'economic_price'
                      when 'fastest'
                        'flight_duration'
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

  def create
    
    @flight = Flight.new(flight_params)

    if @flight.save
      render json: @flight, status: :created
    else
      render json: @flight.errors, status: :unprocessable_entity
    end
  end

  def destroy

    @flight = Flight.find(params[:id]) 

    if @flight.destroy
      flash[:notice] = 'Flight deleted successfully'
    else
      flash[:alert] = 'Failed to delete flight'
    end
    
  end


  def show 

    @flight = Flight.find(params[:id])
    render json: @flight

  end


  def update

    flight = Flight.find(params[:id])
    if flight.update(flight_params)
      render json: flight, status: :ok
    else
      render json: { errors: flight.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def flight_params
    params.require(:flight).permit(
      :from,
      :to,
      :departure_date,
      :business_price,
      :economic_price,
      :flight_duration,
      :stops,
      :company_id
    )

  end



end
