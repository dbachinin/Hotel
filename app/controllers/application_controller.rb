class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    before_action :set_locale
    before_action :configure_permitted_parameters, if: :devise_controller?

    # def extract_locale
    # parsed_locale = request.subdomains.first
    # I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    # end

    #request.original_url.split('.').first.split('//').last
    def set_locale
      I18n.locale = extract_locale || session[:locale] || I18n.default_locale
      session[:locale] = I18n.locale

    end
    def extract_locale
      parsed_locale = request.original_url.split('.').first.split('//').last || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/)[0]
      I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    end

  protected
  
  def configure_permitted_parameters
    added_attrs = [:login, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
