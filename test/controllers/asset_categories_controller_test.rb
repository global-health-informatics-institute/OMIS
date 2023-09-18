require "test_helper"

class AssetCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asset_category = asset_categories(:one)
  end

  test "should get index" do
    get asset_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_asset_category_url
    assert_response :success
  end

  test "should create asset_category" do
    assert_difference("AssetCategory.count") do
      post asset_categories_url, params: { asset_category: { category: @asset_category.category, description: @asset_category.description, voided: @asset_category.voided } }
    end

    assert_redirected_to asset_category_url(AssetCategory.last)
  end

  test "should show asset_category" do
    get asset_category_url(@asset_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_asset_category_url(@asset_category)
    assert_response :success
  end

  test "should update asset_category" do
    patch asset_category_url(@asset_category), params: { asset_category: { category: @asset_category.category, description: @asset_category.description, voided: @asset_category.voided } }
    assert_redirected_to asset_category_url(@asset_category)
  end

  test "should destroy asset_category" do
    assert_difference("AssetCategory.count", -1) do
      delete asset_category_url(@asset_category)
    end

    assert_redirected_to asset_categories_url
  end
end
