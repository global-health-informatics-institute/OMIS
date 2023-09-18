require "application_system_test_case"

class AssetCategoriesTest < ApplicationSystemTestCase
  setup do
    @asset_category = asset_categories(:one)
  end

  test "visiting the index" do
    visit asset_categories_url
    assert_selector "h1", text: "Asset categories"
  end

  test "should create asset category" do
    visit asset_categories_url
    click_on "New asset category"

    fill_in "Category", with: @asset_category.category
    fill_in "Description", with: @asset_category.description
    check "Voided" if @asset_category.voided
    click_on "Create Asset category"

    assert_text "Asset category was successfully created"
    click_on "Back"
  end

  test "should update Asset category" do
    visit asset_category_url(@asset_category)
    click_on "Edit this asset category", match: :first

    fill_in "Category", with: @asset_category.category
    fill_in "Description", with: @asset_category.description
    check "Voided" if @asset_category.voided
    click_on "Update Asset category"

    assert_text "Asset category was successfully updated"
    click_on "Back"
  end

  test "should destroy Asset category" do
    visit asset_category_url(@asset_category)
    click_on "Destroy this asset category", match: :first

    assert_text "Asset category was successfully destroyed"
  end
end
