require "test_helper"

class TimesheetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get timesheets_index_url
    assert_response :success
  end

  test "should get show" do
    get timesheets_show_url
    assert_response :success
  end
end
