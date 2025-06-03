# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # ログインできた後の遷移先
  def after_sign_in_path_for(resource)
    today_path
  end

end
