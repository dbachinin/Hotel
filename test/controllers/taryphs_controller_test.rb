require 'test_helper'

class TaryphsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @taryph = taryphs(:one)
  end

  test "should get index" do
    get taryphs_url
    assert_response :success
  end

  test "should get new" do
    get new_taryph_url
    assert_response :success
  end

  test "should create taryph" do
    assert_difference('Taryph.count') do
      post taryphs_url, params: { taryph: { edate: @taryph.edate, index: @taryph.index, udate: @taryph.udate } }
    end

    assert_redirected_to taryph_url(Taryph.last)
  end

  test "should show taryph" do
    get taryph_url(@taryph)
    assert_response :success
  end

  test "should get edit" do
    get edit_taryph_url(@taryph)
    assert_response :success
  end

  test "should update taryph" do
    patch taryph_url(@taryph), params: { taryph: { edate: @taryph.edate, index: @taryph.index, udate: @taryph.udate } }
    assert_redirected_to taryph_url(@taryph)
  end

  test "should destroy taryph" do
    assert_difference('Taryph.count', -1) do
      delete taryph_url(@taryph)
    end

    assert_redirected_to taryphs_url
  end
end
