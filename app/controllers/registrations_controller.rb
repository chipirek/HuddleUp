class RegistrationsController < Devise::RegistrationsController


  layout "devise/new_registration", only: [:new]


  def update_plan
    @user = current_user
    @user.plan = params[:user][:plan]
    if @user.update_plan_on_stripe
      redirect_to edit_user_registration_path, :notice => 'Updated plan to ' + params[:user][:plan].upcase + '.'
    else
      flash.error = 'Unable to update plan.'
      render :edit
    end
  end


  def update_card
    @user = current_user
    @user.stripe_token = params[:user][:stripe_token]
    if @user.update_card_on_stripe
      redirect_to edit_user_registration_path, :notice => 'Updated card.'
    else
      flash.error = 'Unable to update card.'
      render :edit
    end
  end


end
