require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest

  fixtures :all

  test "login and get to index" do

    @user = users(:me)

    get "/users/sign_in"
    assert_response :success

    post_via_redirect 'users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'lollip0p'
    assert_equal '/', path
    #p flash
    #assert_equal 'Welcome david!', flash[:notice]

    get "/projects"
    assert_response :success
    assert assigns(:projects)
  end


  test "unauthenticated_access_blocked" do

    @user = users(:me)

    get "/projects"
    assert_response 302

    request_via_redirect 'get', 'users/sign_in'
    assert_response :success

  end

end
