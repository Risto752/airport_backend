class CompaniesController < ApplicationController
  def index
    @company_names = Company.all
    render json: @company_names
  end
end
