require "test_helper"

class BusinessAssetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get business_assets_index_url
    assert_response :success
  end

  test "should get new" do
    get business_assets_new_url
    assert_response :success
  end

  test "should get create" do
    get business_assets_create_url
    assert_response :success
  end

  test "should get edit" do
    get business_assets_edit_url
    assert_response :success
  end
end
