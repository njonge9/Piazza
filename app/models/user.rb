class User < ApplicationRecord
  validates :name, presence: true
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  has_many :memberships, dependent: :destroy
  has_many :organization, through: :memberships

  # Method to remove extraneous spaces
  before_validation :strip_extraneous_spaces

  # password length and security
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }

  # A user can have many app sessions
  has_many :app_sessions

  def self.create_app_session(email:, password:)
    return nil unless user = User.find_by(email: email.downcase)

    user.app_sessions.create if user.authenticate(password)
  end

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private

  def strip_extraneous_spaces
    self.name = self.name&.strip
    self.email = self.email&.strip
  end
end
