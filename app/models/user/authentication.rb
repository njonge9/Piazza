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
end
