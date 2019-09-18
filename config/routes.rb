Rails.application.routes.draw do
scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
end
  get 'brands/upload_image', to: 'brands#upload_image'


  resources :brands
  get 'start/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

root 'start#index'

end
