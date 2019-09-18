class ApplicationController < ActionController::Base
        before_action :set_locale, :set_js_translations
        protect_from_forgery with: :exception



       private

        def set_js_translations
                ap 'GET TRANS'
                @translations = I18n.t(".")
                ap @translations

        end

       def set_locale
        I18n.locale = params[:locale] || I18n.default_locale
       end 
       def default_url_options(options = {})
       {locale: I18n.locale}.merge options
        end
end
