module User::PasswordReset
  extend ActiveSupport::Concern

  included do
    has_secure_password :password_reset_token, validation: false
  end

  def reset_password
    update(
      password_reset_token: self.class.generate_unique_secure_token
    )
    app_sessions.destroy_all

    send_password_reset_email
  end

  private

  def send_password_reset_email
    UserMailer.with(user: self)
              .password_reset
              .deliver_now
  end
end
