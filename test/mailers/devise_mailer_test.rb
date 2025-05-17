require 'test_helper'

class DeviseMailerTest < ActionMailer:: TestCase

  test 'confirmation_instructions' do
    @user = users(:user1)
    raw,enc = Devise.token_generator.generate(User, :confirmation_token) # token_generatorはDeviseモジュールのクラス変数、初期値nil
    @user.confirmation_token = enc 
    mail = Devise::Mailer.confirmation_instructions(@user, @user.confirmation_token) # メールを送信

    assert_equal '【重要】アカウントの有効化について', mail.subject
    assert_equal [@user.email],mail.to
    assert_equal ["devtest@example.com"],mail.from # from はconfig/initializer/devise.rb config.mailer_senderを参照
    assert_match @user.confirmation_token, mail.body.encoded
  end

end