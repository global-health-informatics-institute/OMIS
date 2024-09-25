require "test_helper"

class RequisitionItemControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get requisition_item_show_url
    assert_response :success
  end
end
