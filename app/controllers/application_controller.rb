class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'You need to be signed in to use this feature.' if current_user.nil?
  end

  def admin_user
    User.find(session[:user_id]).admin
  end

  def ensure_that_user_is_admin
    redirect_to current_user, notice: 'You are not an admin.' unless admin_user
  end
end
