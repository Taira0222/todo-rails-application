#Preview all emails at http://localhost:3000/rails/mailers/devise_mailer

class DeviseMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/devise_mailer/confirmation_instructions
  def confirmation_instructions
    user = User.last
    raw,enc = Devise.token_generator.generate(User, :confirmation_token) # token_generatorはDeviseモジュールのクラス変数、初期値nil
    user.confirmation_token ||= enc
    Devise::Mailer.confirmation_instructions(user, user.confirmation_token)
  end
end

