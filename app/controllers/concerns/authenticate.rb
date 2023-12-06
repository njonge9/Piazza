module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
    before_action :require_login, unless: :logged_in?

    helper_method :logged_in?
  end

  protected

  # A method to store the users data in an encrypted cookie
  # This cookie will last for 20 years by chaining permanent
  # User wont be logged out if they close the browser or the app
  def log_in(app_session)
    cookies.encrypted.permanent[:app_session] = {
      value: app_session.to_h
    }
  end

  private

  def authenticate
    Current.app_session = authenticate_using_cookie
    Current.user = Current.app_session&.user
  end

  # Extract the data from the encrypted cookie
  def authenticate_using_cookie
    app_session = cookies.encrypted[:app_session]
    authenticate_using app_session&.with_indifferent_access
  end

  def authenticate_using(data)
    # deconstruct the hash into variables using Ruby 3 rightward assignment
    data => { user_id:, app_session:, token:}

    user = User.find(user_id)
    user.authenticate_app_session(app_session, token)
  rescue NoMatchingPatternError, ActiveRecord::RecordNotFound
    nil
  end
end
