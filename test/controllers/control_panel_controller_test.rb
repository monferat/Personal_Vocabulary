require 'test_helper'

class ControlPanelControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get control_panel_index_url
    assert_response :success
  end

  test "should get new" do
    get control_panel_new_url
    assert_response :success
  end

  test "should get create" do
    get control_panel_create_url
    assert_response :success
  end

  test "should get destroy" do
    get control_panel_destroy_url
    assert_response :success
  end

end
