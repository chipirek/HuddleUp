require 'test_helper'

class SmokeTest < ActionDispatch::IntegrationTest

  fixtures :all


  test 'login and get to index' do
    #@user = users(:me)

    get '/users/sign_in'
    assert_response :success

    post_via_redirect 'users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'lollip0p'
    assert_equal '/', path
    #p flash
    #assert_equal 'Welcome david!', flash[:notice]

    get '/projects'
    assert_response :success
    assert assigns(:projects)
  end


  test 'unauthenticated_access_blocked' do
    @user = users(:me)

    get '/projects'
    assert_response 302

    request_via_redirect 'get', 'users/sign_in'
    assert_response :success
  end


  test 'attempted sign in fails with bad credentials' do
    get '/users/sign_in'
    assert_response :success

    post_via_redirect '/users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'wrong'
    assert_equal '/users/sign_in', path
    assert_equal 'Invalid email or password.', flash[:alert]
  end


=begin

  test 'registration OK' do
    get '/users/sign_up'
    assert_response :success

    post_via_redirect '/users', 'user[name]' => 'New User','user[email]' => 'new_user@gmail.com', 'user[password]' => 'lollip0p', 'user[password_confirmation]' => 'lollip0p', 'project_name' => 'New Project'
    assert_equal '/', path
  end


  test 'registration fails with missing fields' do
    get '/users/sign_up'
    assert_response :success

    post_via_redirect '/users', 'user[name]' => 'New User3', 'user[password]' => 'lollip0p', 'project_name' => 'New Project'
    assert_equal '/users', path
  end


  test 'registration fails with missing project name' do
    get '/users/sign_up'
    assert_response :success

    post_via_redirect '/users', 'user[name]' => 'New User3','user[email]' => 'new_user3@gmail.com', 'user[password]' => 'lollip0p', 'user[password_confirmation]' => 'lollip0p'
    assert_equal '/users', path
  end

=end

  
  test 'create new project' do

    #-- login
    get '/users/sign_in'
    assert_response :success

    post_via_redirect 'users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'lollip0p'
    assert_equal '/', path

    #-- get the index
    get '/projects'
    assert_response :success
    assert assigns(:projects)

    get '/projects/new'
    assert_response :success

    post_via_redirect '/projects', 'project[name]' => 'My Integration Test Project'

    # p 'Verifying...'
    p = Project.last
    assert_equal '/projects/' + p.id.to_s, path
    assert_equal p.name, 'My Integration Test Project'
  end


  test 'edit a project' do
    #-- login
    get '/users/sign_in'
    assert_response :success

    post_via_redirect 'users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'lollip0p'
    assert_equal '/', path

    #-- get the edit page
    prj = Project.find(1)  #where('name=?', 'Project fixture 1').first
    assert_equal 1, prj.id
    assert_equal prj.name, 'Project fixture 1'

    get '/projects/' + prj.id.to_s + '/edit'
    assert_response :success

    put_via_redirect '/projects/' + prj.id.to_s, 'project[name]' => 'Project fixture 1 -e'

    assert_equal '/projects/' + prj.id.to_s, path
    prj = Project.find(1)  # get the fresh copy from the database
    assert_equal prj.name, 'Project fixture 1 -e'
  end


  test 'delete a project' do
    #-- login
    get '/users/sign_in'
    assert_response :success

    post_via_redirect 'users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'lollip0p'
    assert_equal '/', path

    count_before_delete = Project.all.count
    p = Project.last

    #-- get the index
    get '/projects'
    assert_response :success
    assert assigns(:projects)

    delete_via_redirect '/projects/' + p.id.to_s

    assert_equal '/projects', path

    #new_p = Project.last
    #assert_not_equal p.id, new_p.id
    count_after_delete = Project.all.count
    assert_not_equal count_before_delete, count_after_delete
  end


  test 'create new todo' do

    #p = projects(:project1)
    p = Project.first

    #-- login
    get '/users/sign_in'
    assert_response :success

    post_via_redirect 'users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'lollip0p'
    assert_equal '/', path
    #p flash
    #assert_equal 'Welcome david!', flash[:notice]

    #-- get the index
    get project_todos_path (p)
    assert_response :success
    assert assigns(:todos)

    #-- get the add page
    get new_project_todo_path (p)
    assert_response :success

    #-- post the form / add the object
    # p project_todos_path (p)
    # p p.name
    post_via_redirect project_todos_path (p), 'todo[subject]' => 'My Integration Test Todo', 'todo[due_date]' => '12/25/13'

    #-- get the fresh copy from the database
    #p = projects(:project1)
    p = Project.first
    t = p.todos.first
    assert_equal t.subject, 'My Integration Test Todo'

  end


  test 'update a todo' do

    #-- login
    get '/users/sign_in'
    assert_response :success

    post_via_redirect 'users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'lollip0p'
    assert_equal '/', path
    #p flash
    #assert_equal 'Welcome david!', flash[:notice]

    #-- create a working project
    post_via_redirect '/projects', 'project[name]' => 'My Working Project'
    p = Project.last

    #-- create a todo to work with
    post_via_redirect '/projects/' + p.id.to_s + '/todos', 'todo[subject]' => 'Some Todo', 'todo[due_date]' => '12/25/13'

    #-- now get the edit page for that item
    get edit_project_todo_path(p, p.todos.first.id)
    assert_response :success

    #-- post the form
    put_via_redirect '/projects/' + p.id.to_s + '/todos/' + p.todos.first.id.to_s, 'todo[subject]' => '-e', 'todo[due_date]' => '12/25/13'

    #-- get the fresh copy from the database
    p = Project.last
    t = p.todos.first
    assert_equal t.subject, '-e'

  end


  test 'add an issue to a project' do
    p = Project.first

    #-- login
    get '/users/sign_in'
    assert_response :success

    post_via_redirect 'users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'lollip0p'
    assert_equal '/', path

    #-- get the issues index
    get project_issues_path (p)
    assert_response :success
    assert assigns(:issues)

    #-- get the add page
    get new_project_issue_path (p)
    assert_response :success

    #-- post the form / add the object
    post_via_redirect project_issues_path (p), 'issue[description]' => 'This is my issue'

    #-- get the fresh copy from the database
    p = Project.first
    i = p.issues.first
    assert_equal i.description, 'This is my issue'
    assert_not_equal p.issues.count, 0
  end

  test 'create new message' do

    #p = projects(:project1)
    p = Project.first

    #-- login
    get '/users/sign_in'
    assert_response :success

    post_via_redirect 'users/sign_in', 'user[email]' => 'chip.irek@gmail.com', 'user[password]' => 'lollip0p'
    assert_equal '/', path
    #p flash
    #assert_equal 'Welcome david!', flash[:notice]

    #-- get the index
    get project_messages_path (p)
    assert_response :success
    assert assigns(:messages)

    #-- get the add page
    get new_project_message_path (p)
    assert_response :success

    #-- post the form / add the object
    # p project_todos_path (p)
    # p p.name
    post_via_redirect project_messages_path (p), 'message[subject]' => 'My Message'

    #-- get the fresh copy from the database
    #p = projects(:project1)
    p = Project.first

    assert_equal 1, p.messages.count

    t = p.messages.first
    assert_equal 'My Message', t.subject

  end



end

