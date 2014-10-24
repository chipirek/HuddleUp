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
  end


  def update
    super
  end


end
