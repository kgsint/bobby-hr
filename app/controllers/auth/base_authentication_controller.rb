class Auth::BaseAuthenticationController < ApplicationController
  layout 'auth'
  skip_before_action :authenticate_user

end
