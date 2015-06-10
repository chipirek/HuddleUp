class RegistrationsController < Devise::RegistrationsController


  layout "devise/new_registration" #, only: [:new, :edit]

  before_filter :configure_permitted_parameters, if: :devise_controller?


  # 4242424242424242	Visa
  # 5555555555554444	MasterCard


  def update_card
    @user = current_user
    @user.stripe_token = params[:user][:stripe_token]
    if @user.update_card_on_stripe
      redirect_to edit_user_registration_path, :notice => 'Updated card.'
    else
      flash[:error] = 'Credit card billing provider error -- unable to save card.'
      render :edit
    end
  end


  protected


  def after_update_path_for(user)
    "/" #edit_user_registration_path
  end


  def after_sign_in_path_for(user)
    root_path
  end


  def after_sign_up_path_for(user)
    edit_user_registration_path  #this bypasses the index.html marketing page
  end


  private


  def configure_permitted_parameters

    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :plan, :password, :password_confirmation)
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :plan, :current_password)
    end

  end


  def user_params
    params.require(:user).permit(:name, :email, :plan, :password, :password_confirmation)
  end


end
