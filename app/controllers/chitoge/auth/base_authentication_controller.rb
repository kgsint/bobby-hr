module Chitoge
  class Auth::BaseAuthenticationController < ::ApplicationController
    layout 'auth_chitoge'

    skip_before_action :authenticate_user
  end
end
