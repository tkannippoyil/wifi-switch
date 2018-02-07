require 'test_helper'

class DevicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get devices_index_url
    assert_response :success
  end

  test "should get turn_on" do
    get devices_turn_on_url
    assert_response :success
  end

  test "should get torn_off" do
    get devices_torn_off_url
    assert_response :success
  end

  test "should get restart" do
    get devices_restart_url
    assert_response :success
  end

  test "should get torn_on_all" do
    get devices_torn_on_all_url
    assert_response :success
  end

  test "should get turn_off_all" do
    get devices_turn_off_all_url
    assert_response :success
  end

  test "should get toggle_all" do
    get devices_toggle_all_url
    assert_response :success
  end

end
