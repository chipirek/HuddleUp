class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end


  def create
    build_resource

    if resource.save

      @project = Project.new(:name=>params[:project_name], :status_code=>1)
      if @project.save

        @member = Member.new(:project_id=>@project.id, :user_id=>resource.id, :joined_date=>Time.now, :is_admin=>true)
        if @member.save
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

  end


  def update
    super
  end

end
