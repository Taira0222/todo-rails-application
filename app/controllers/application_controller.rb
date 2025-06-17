class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_signed_in_user_to_today_path, if: :user_signed_in?
  if Rails.env.production?
    allow_browser versions: :modern
  end


  protected

  # ログインとアカウント更新のstrong parameterにnameを追加した。
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  private

  # remember_meが有効なら、today_pathにredirectする
  def redirect_signed_in_user_to_today_path
    if request.path == root_path
      redirect_to today_path
    end
  end
end
