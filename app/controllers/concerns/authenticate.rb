module Authenticate
  extend Activesupport::Concern

  protected

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

  def authenticate_using_cookie
    app_session = cookies.encrypted[:app_session]
    authenticate_using app_session&.with_indifferent_access
  end

  def authenticate_using(data)
    data => { user_id:, app_session:, token:}

    user = User.find(user_id)
    user.authenticate_app_session(app_session, token)
  rescue NoMatchingPatternError, ActiveRecord::RecordNotFound
    nil
  end
end
