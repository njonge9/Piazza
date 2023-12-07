module User::PasswordReset
  extend ActiveSupport::Concern

  included do
    has_secure_password :password_reset_token, validation: false
  end
end
