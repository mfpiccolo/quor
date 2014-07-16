class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def track_activity(trackable, ignore=nil)
    current_user.activities.create!(
      controller: params[:controller],
      action: params[:action],
      trackable: trackable,
      messages: activity_message(trackable, params, ignore)
    )
  end
end
