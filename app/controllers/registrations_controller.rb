class RegistrationsController < Devise::RegistrationsController


  layout "devise/new_registration", only: [:new]


  # 4242424242424242	Visa
  # 5555555555554444	MasterCard

  def update_card
    @user = current_user
    @user.stripe_token = params[:user][:stripe_token]
    if @user.update_card_on_stripe
      redirect_to edit_user_registration_path, :notice => 'Updated card.'
    else
      flash[:error] = 'Credit card billing provider error: Unable to save card.'
      render :edit
    end
  end


  protected


  def after_update_path_for(user)
    edit_user_registration_path
  end


  def after_sign_in_path_for(user)
    root_path
  end


  def after_sign_up_path_for(user)
    edit_user_registration_path  #this bypasses the index.html marketing page
  end



end
