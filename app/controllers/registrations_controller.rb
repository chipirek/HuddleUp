class RegistrationsController < Devise::RegistrationsController

  layout "devise/new_registration", only: [:new]

  def new
    super
  end

  # this method overrides the base class
  def create
    build_resource
    resource.plan = 'free'
    if !resource.save
      clean_up_passwords resource
      messages = resource.errors.full_messages.map { |msg| "<li>" + msg + "</li>" }.join
      flash[:alert] = messages
      redirect_to '/users/sign_up'
    else
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_up(resource_name, resource)
      respond_with resource, :location => after_sign_up_path_for(resource)
    end

=begin
    # --- build the devise user, called a 'resource'
    build_resource

    if resource.save   #--- if it saves ok...

      #--- create a project object
      project = Project.new(:name=>params[:project_name], :status_code=>1)
      if project.save   #--- if it saves ok...

        #--- create a member object
        member = Member.new(:project_id=>@project.id, :user_id=>resource.id, :joined_date=>Time.now, :is_admin=>true)
        if member.save
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_up(resource_name, resource)
          respond_with resource, :location => after_sign_up_path_for(resource)
        else
          resource.errors.add('Member', ' creation had a fatal error.')
          clean_up_passwords resource
          respond_with resource
        end

      else
        resource.errors.add('Project', ' name cannot be blank.')
        clean_up_passwords resource
        respond_with resource, :location => '/users/sign_up'
      end
    else
      resource.errors.add('Registration', ' failed.  Does this email already exist in the system?')
      clean_up_passwords resource
      respond_with resource
    end
=end

  end


  def update
    super
  end

end
