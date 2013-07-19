require 'test_helper'

class SmokeTest < ActionDispatch::IntegrationTest

  fixtures :all

  test "login and get to index" do
    #@user = users(:me)

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


  test "attempted sign in fails with bad credentials" do
    get "/users/sign_in"
    assert_response :success

    post_via_redirect '/users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'wrong'
    assert_equal "/users/sign_in", path
    assert_equal 'Invalid email or password.', flash[:alert]
  end


  test "registration OK" do
    get "/users/sign_up"
    assert_response :success

    post_via_redirect '/users', 'user[name]' => 'New User','user[email]' => 'new_user@gmail.com', 'user[password]' => 'lollip0p', 'user[password_confirmation]' => 'lollip0p', 'project_name' => 'New Project'
    assert_equal "/", path
  end


  test "registration fails with missing fields" do
    get "/users/sign_up"
    assert_response :success

    post_via_redirect '/users', 'user[name]' => 'New User3', 'user[password]' => 'lollip0p', 'project_name' => 'New Project'
    assert_equal "/users", path
  end


  test "registration fails with missing project name" do
    get "/users/sign_up"
    assert_response :success

    post_via_redirect '/users', 'user[name]' => 'New User3','user[email]' => 'new_user3@gmail.com', 'user[password]' => 'lollip0p', 'user[password_confirmation]' => 'lollip0p'
    assert_equal "/users", path
  end


end
