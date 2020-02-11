class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # 新規登録時にnameキーのパラメーターを追加で許可する
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    added_attrs = [ :email, :user_name, :password, :password_confirmation ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    user_path(resource.id)
  end
end
