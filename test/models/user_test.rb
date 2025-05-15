require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'should be invalid with name ' do
    user = User.new(name: '',
                    email: 'test@example.com',
                    password: 'password',
                    password_confirmation: 'password')
    assert_not user.valid?
  end

  test 'should be valid with name' do
    user = User.new(name: 'Takeshi',
                    email: 'test@example.com',
                    password: 'password',
                    password_confirmation: 'password')
    assert user.valid?
  end

  test 'should be invalid with 31 charactors' do
    name = 'a'*31
    user = User.new(name: name,
                    email: 'test@example.com',
                    password: 'password',
                    password_confirmation: 'password')
    assert_not user.valid?               
  end

  test 'should be valid within 30 charactors' do
    name = 'a'*30
    user = User.new(name: name,
                    email: 'test@example.com',
                    password: 'password',
                    password_confirmation: 'password')
    assert user.valid?               
  end

end