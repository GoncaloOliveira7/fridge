Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'recipes/index'
    end
  end

  root "base#index"
end
