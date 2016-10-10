Rails.application.routes.draw do
  resources :docs
  mount Hashtags::Engine => '/'
end
