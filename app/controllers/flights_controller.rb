class FlightsController < ApplicationController
  def index
    query = Flight.all

    permitted_params = params.permit(:company_id, :stops, :from, :to, :select_sort_state, :sort_toggle,
      :business_min, :business_max, :economic_min, :economic_max)

    if permitted_params.present?
      query = query.where(company_id: permitted_params[:company_id]) if permitted_params[:company_id].present?
      query = query.where(stops: permitted_params[:stops]) if permitted_params[:stops].present?
      query = query.where('flights.from LIKE ?', "%#{permitted_params[:from]}%") if permitted_params[:from].present?
      query = query.where('flights.to LIKE ?', "%#{permitted_params[:to]}%") if permitted_params[:to].present?

      if permitted_params[:select_sort_state].present? && permitted_params[:sort_toggle].present?
        column_name = case permitted_params[:select_sort_state]
                      when 'Cheapest business price'
                        'business_price'
                      when 'Cheapest economic price'
                        'economic_price'
                      when 'Fastest'
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

      render json: query.to_json
    else
      render json: query.to_json
    end
  end
end
