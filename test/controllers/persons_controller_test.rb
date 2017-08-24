require 'test_helper'

class PersonsControllerTest < ActionDispatch::IntegrationTest
  test "should get getall" do
    get persons_getall_url
    assert_response :success
  end

end
