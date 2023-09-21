require "test_helper"

class ProjectTaskAssignmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get project_task_assignments_index_url
    assert_response :success
  end

  test "should get new" do
    get project_task_assignments_new_url
    assert_response :success
  end

  test "should get create" do
    get project_task_assignments_create_url
    assert_response :success
  end

  test "should get edit" do
    get project_task_assignments_edit_url
    assert_response :success
  end
end
