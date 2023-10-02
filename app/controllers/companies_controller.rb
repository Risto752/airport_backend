class CompaniesController < ApplicationController
  def index
    @company_names = Company.select(:id, :title)
    render json: @company_names
  end
end
