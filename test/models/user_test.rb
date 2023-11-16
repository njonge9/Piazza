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
    assert_not @user.valid?
  end
end
