require "test_helper"

class EstablishmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get establishments_show_url
    assert_response :success
  end

  test "should get index" do
    get establishments_index_url
    assert_response :success
  end

  test "should get new" do
    get establishments_new_url
    assert_response :success
  end

  test "should get create" do
    get establishments_create_url
    assert_response :success
  end

  test "should get edit" do
    get establishments_edit_url
    assert_response :success
  end

  test "should get update" do
    get establishments_update_url
    assert_response :success
  end

  test "should get destroy" do
    get establishments_destroy_url
    assert_response :success
  end
end
