require "test_helper"

class RequisitionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get requisitions_index_url
    assert_response :success
  end

  test "should get new" do
    get requisitions_new_url
    assert_response :success
  end

  test "should get create" do
    get requisitions_create_url
    assert_response :success
  end

  test "should get edit" do
    get requisitions_edit_url
    assert_response :success
  end
end
