require "test_helper"

class TimeSheetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get time_sheets_index_url
    assert_response :success
  end

  test "should get new" do
    get time_sheets_new_url
    assert_response :success
  end

  test "should get create" do
    get time_sheets_create_url
    assert_response :success
  end

  test "should get edit" do
    get time_sheets_edit_url
    assert_response :success
  end
end
