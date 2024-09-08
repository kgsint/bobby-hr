class Auth::BaseAuthenticationController < ApplicationController
  # before_action :guest_user_only
  skip_before_action :authenticate_user

end
