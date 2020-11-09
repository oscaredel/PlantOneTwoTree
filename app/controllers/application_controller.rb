class ApplicationController < ActionController::Base
  # To get the Twitter API to work, (CSRF)
  protect_from_forgery with: :null_session
end
