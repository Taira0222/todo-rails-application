# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # 確認メール再送信画面
  def new
    super
  end

  # 確認メール再送信
  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # 確認メール再送信後の画面遷移先(基本はlogin_path)
  def after_resending_confirmation_instructions_path_for(resource_name)
    super(resource_name)
  end

  # 確認メールのリンクをクリックした後にリダイレクトする先(基本はlogin_path)
  def after_confirmation_path_for(resource_name, resource)
    super(resource_name, resource)
  end
end
