# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # 会員登録のparamsの値の許可
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # ユーザー更新のparamの値の許可
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  # パスワード抜き(nameとemail)で情報更新
  def update_resource(resource, params)
    resource.update_without_password(params) # devise/lib/devise/models/database_authentivatable.rb 120行目参照
  end

  # サインアップをした後の画面遷移先
  def after_inactive_sign_up_path_for(resource)
    confirmation_sent_path
  end

  # アカウント情報(メールやパスワード)更新した後の画面遷移先
  def after_update_path_for(resource)
    user_signed_in? ? today_path : root_path
  end
end
