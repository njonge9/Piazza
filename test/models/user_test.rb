require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'requires a name' do
    @user = User.new(name: '', email: 'johndoe@example.com')
    assert_not @user.valid?

    @user.name = 'John'
    assert @user.valid?
  end

  test 'requires a valid email' do
    @user = User.new(name: 'John', email: '')
    assert_not @user.valid?

    @user.email = 'invalid'
    assert_not @user.valid?

    @user.email = 'johndoe@example.com'
    assert @user.valid?
  end

  test 'require a unique email' do
    @existing_user = User.create(name: 'John', email: 'jdoe@exampe.com')
    assert @existing_user.persisted?

    @user = User.new(name: 'John', email: 'jdoe@example.com')
    assert @user.valid?
  end

  test 'name and email is stripped of spaces before saving' do
    @user = User.create(
      name: 'John ',
      email: ' john@example.com',
    )

    assert_equal 'John', @user.name
    assert_equal 'john@example.com', @user.email
  end

  # test for length of password
  test "password length must be between 8 and ActiveModels maximum" do
    @user = User.new(
      name: "Jane",
      email: "janedoe@example.com",
      password: ""
    )
    assert_not @user.valid?

    @user.password = "password"
    assert @user.valid?

    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = "a" * (max_length + 1)
    assert_not @user.valid?
  end
end
