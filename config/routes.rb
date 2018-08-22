Rails.application.routes.draw do
  devise_for :users
  root 'parsers#input'

  get '/contact', to: 'static_pages#contact'
  get '/help', to: 'static_pages#help'
  post '/send_email', to: 'static_pages#send_email'

  get '/output', to: 'parsers#output'
  post '/output', to: 'parsers#output'
  patch '/output', to: 'parsers#output'

  get '/csv_out', to: 'parsers#csv_out'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
