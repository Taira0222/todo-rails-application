#Preview all emails at http://localhost:3000/rails/mailers/devise_mailer

class DeviseMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/devise_mailer/confirmation_instructions
  def confirmation_instructions
    user = User.last
    user.send_confirmation_instructions
    raw_token = user.instance_variable_get(:@raw_confirmation_token)
    Devise::Mailer.confirmation_instructions(user, raw_token)
  end

  # http://localhost:3000/rails/mailers/devise_mailer/email_changed
  def email_changed
    user = User.last
    Devise::Mailer.email_changed(user)
  end

  # http://localhost:3000/rails/mailers/devise_mailer/reset_password_instructions
  def reset_password_instructions
    user = User.last
    raw_token = user.send_reset_password_instructions
    Devise::Mailer.reset_password_instructions(user, raw_token)
  end
end

