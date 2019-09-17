Rails.application.routes.draw do
scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
end
  resources :brands
  get 'start/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

root 'start#index'


end
