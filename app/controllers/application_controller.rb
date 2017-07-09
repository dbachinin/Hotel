class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    before_action :set_locale, :configure_permitted_parameters, if: :devise_controller?

  protected
    def extract_locale
    parsed_locale = request.subdomains.first
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    end
    
    def set_locale
      I18n.locale = extract_locale || I18n.default_locale
    end

  def configure_permitted_parameters
    added_attrs = [:login, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
