module User::Authentication
  extend ActiveSupport::Concern

  included do
    # password length and security
    has_secure_password
    validates :password, on: [:create, :password_change], presence: true, length: { minimum: 8 }

    # A user can have many app sessions
    has_many :app_sessions
  end

  class_methods do
    def create_app_session(email:, password:)
      return nil unless user = User.find_by(email: email.downcase)

      user.app_sessions.create if user.authenticate(password)
    end
  end

  private

  def send_password_reset_email
    UserMailer.with(user: self)
              .password_reset(CGI.escape(password_reset_id))
              .deliver_now
  end

  def password_reset_id
    message_verifier.generate({
      user_id: id,
      password_reset_token: password_reset_token
    }, purpose: :password_reset, expires_in: 2.hours)
  end
end
