require "test_helper"

class DeviseMailerTest < ActionMailer:: TestCase
  include Rails.application.routes.url_helpers

  test "confirmation_instructions" do
    @user = users(:user1)
    raw_token, enc_token = Devise.token_generator.generate(User, :confirmation_token)
    @user.update(confirmation_token: enc_token)

    mail = Devise::Mailer.confirmation_instructions(@user, raw_token) # メールを送信

    assert_equal [ @user.email ], mail.to
    assert_equal "【重要】アカウントの有効化について", mail.subject
    assert_equal [ Devise.mailer_sender ], mail.from # from はconfig/initializer/devise.rb config.mailer_senderを参照
    assert_match @user.name, mail.body.encoded
    escaped = CGI.escapeHTML(raw_token) # raw_tokenをhtmlエンコード
    assert_match escaped, mail.body.encoded
  end

  test "email_changed mailer" do
    # email_changed の動作確認
    @user = users(:user1)
    @user.unconfirmed_email = "goda@example.com" # これから登録するメールアドレス

    mail = Devise::Mailer.email_changed(@user)

    assert_equal [ @user.email ], mail.to
    assert_equal "【重要】メールアドレス変更について", mail.subject
    assert_equal [ Devise.mailer_sender ], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.unconfirmed_email, mail.body.encoded
  end

  test "reset_password_instructions" do
    @user = users(:user1)
    raw_token, enc_token = Devise.token_generator.generate(User, :reset_password_token)
    @user.update(reset_password_token: enc_token)
    mail = Devise::Mailer.reset_password_instructions(@user, raw_token) # メールを送信

    assert_equal [ @user.email ], mail.to
    assert_equal "【重要】パスワードの再設定について", mail.subject
    assert_equal [ Devise.mailer_sender ], mail.from # from はconfig/initializer/devise.rb config.mailer_senderを参照
    assert_match @user.name, mail.body.encoded
    escaped = CGI.escapeHTML(raw_token) # raw_tokenをhtmlエンコード
    assert_match escaped, mail.body.encoded
  end
end
