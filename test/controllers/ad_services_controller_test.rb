require 'test_helper'

class AdServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ad_service = ad_services(:one)
  end

  test "should get index" do
    get ad_services_url
    assert_response :success
  end

  test "should get new" do
    get new_ad_service_url
    assert_response :success
  end

  test "should create ad_service" do
    assert_difference('AdService.count') do
      post ad_services_url, params: { ad_service: { enable: @ad_service.enable, name: @ad_service.name, price: @ad_service.price } }
    end

    assert_redirected_to ad_service_url(AdService.last)
  end

  test "should show ad_service" do
    get ad_service_url(@ad_service)
    assert_response :success
  end

  test "should get edit" do
    get edit_ad_service_url(@ad_service)
    assert_response :success
  end

  test "should update ad_service" do
    patch ad_service_url(@ad_service), params: { ad_service: { enable: @ad_service.enable, name: @ad_service.name, price: @ad_service.price } }
    assert_redirected_to ad_service_url(@ad_service)
  end

  test "should destroy ad_service" do
    assert_difference('AdService.count', -1) do
      delete ad_service_url(@ad_service)
    end

    assert_redirected_to ad_services_url
  end
end
