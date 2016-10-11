Hashtags::Engine.routes.draw do
  namespace :hashtags do
    get 'resources' => 'resources#index', as: :resources
  end
end
