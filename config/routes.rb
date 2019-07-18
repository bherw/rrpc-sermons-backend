Rails.application.routes.draw do
  namespace :v0 do
    get 'biblesearch/*query', to: 'bible_search#query', format: false
    resources :series, defaults: { format: 'json' }
    resources :sermon, defaults: { format: 'json' }
    resources :speakers, defaults: { format: 'json' }
  end
end
