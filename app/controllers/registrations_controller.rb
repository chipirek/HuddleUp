class RegistrationsController < Devise::RegistrationsController


  layout "devise/new_registration", only: [:new]


end
