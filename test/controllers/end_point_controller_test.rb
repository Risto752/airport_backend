require 'test_helper'

class EndPointControllerTest < ActionDispatch::IntegrationTest
  test "should get the_great_filter" do
    get end_point_the_great_filter_url
    assert_response :success
  end

  test "should get get_companies" do
    get end_point_get_companies_url
    assert_response :success
  end

  test "should get get_company_names" do
    get end_point_get_company_names_url
    assert_response :success
  end

end
