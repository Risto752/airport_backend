class EndPointController < ApplicationController
  def the_great_filter
    companyName = params[:param1]
    stops = params[:param2]
    location = params[:param3]
    selectSortState = params[:param4]
    sortToggle = params[:param5]
    rangeValuesBusiness = params[:param6]
    rangeValuesEconomic = params[:param7]

    # Start with a base query that joins the companies and flights tables
    query = Company.joins(:flights)

    render json: query.to_json

    # Check and filter by companyName if present
    query = query.where('companies.company_name = ?', params[:param1]) if params[:param1].present?

    # Check and filter by stops if present
    query = query.where('flights.stops = ?', params[:param2]) if params[:param2].present?

    # Check and filter by location if present
    query = query.where('flights.location = ?', params[:param3]) if params[:param3].present?

    # Check and filter by other parameters in a similar way

    # Sorting
    if params[:param4].present? && params[:param5].present? && (params[:param4] == 'Cheapest business price')
      query = query.order('business_price ASC') if params[:param5] == 'asc'
      query = query.order('business_price DESC') if params[:param5] == 'desc'
    end

    if params[:param4].present? && params[:param5].present? && (params[:param4] == 'Cheapest economic price')
      query = query.order('economic_price ASC') if params[:param5] == 'asc'
      query = query.order('economic_price DESC') if params[:param5] == 'desc'
    end

    if params[:param4].present? && params[:param5].present? && (params[:param4] == 'Fastest')
      query = query.order('fligth_duration ASC') if params[:param5] == 'asc'
      query = query.order('fligth_duration DESC') if params[:param5] == 'desc'
    end

    # Add more sorting options as needed

    # Filtering by numeric ranges
    if params[:param6].present?
      min_value = params[:param6][0]
      max_value = params[:param6][1]
      query = query.where('flights.business_column >= ? AND flights.business_column <= ?', min_value, max_value)
    end

    if params[:param7].present?
      min_value = params[:param7][0]
      max_value = params[:param7][1]
      query = query.where('flights.economic_column >= ? AND flights.economic_column <= ?', min_value, max_value)
    end

    # Execute the final query
    # render json: query.all.to_json
  end

  def get_companies
    companies = Company.includes(:flights)
    @companies_with_flights = companies.map do |company|
      {
        id: company.id,
        title: company.title,
        flights: company.flights
      }
    end
    render json: @companies_with_flights.to_json
  end

  def get_company_names
    @company_names = Company.select(:id, :title)
    render json: @company_names
  end
end
