Rails.application.routes.draw do
  namespace :v0 do
    get 'biblesearch/*query', to: 'bible_search#query', format: false
    resources :sermon, defaults: { format: 'json' }
  end
end
