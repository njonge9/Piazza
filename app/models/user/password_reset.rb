module User::PasswordReset
  extend ActiveSupport::Concern

  included do
    has_secure_password :password_reset_token, validation: false

    before_save -> { self.password_reset_token = nil },
      if: -> { password_digest_change_to_be_saved.present?}
  end

  class_methods do
    def find_by_password_reset_id(id)
      message_verifier.verified(
        CGI.unescape(id),
        purpose: :password_reset
      )&.symbolize_keys => { user_id:, password_reset_token:}

      User.find(user_id)
          .authenticate_password_reset_token(password_reset_token)
      rescue ActiveRecord::RecordNotFound, NoMatchingPatternError
        nil
    end
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
              .password_reset(self.password_reset_token)
              .deliver_now
  end
end
