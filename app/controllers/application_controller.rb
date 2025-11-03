class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_guest_token

  private

  def set_guest_token
    session[:guest_token] ||= SecureRandom.uuid
  end

  def current_guest_token
    session[:guest_token]
  end
  helper_method :current_guest_token
end
