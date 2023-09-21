require "test_helper"

class TimeSheetTasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get time_sheet_tasks_index_url
    assert_response :success
  end

  test "should get new" do
    get time_sheet_tasks_new_url
    assert_response :success
  end

  test "should get create" do
    get time_sheet_tasks_create_url
    assert_response :success
  end

  test "should get edit" do
    get time_sheet_tasks_edit_url
    assert_response :success
  end
end
