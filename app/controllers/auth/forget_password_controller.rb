class Auth::ForgetPasswordController < ApplicationController
  layout 'auth'
  skip_before_action :authenticate_user
 def new
  
 end

end
