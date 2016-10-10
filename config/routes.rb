Hashtags::Engine.routes.draw do
  get 'resources' => 'resources#index', as: :resources
end
