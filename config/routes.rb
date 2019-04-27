Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/login')
  get 'login', to: 'repo#login'
  get 'repos', to: 'repo#repos'
  post 'repos', to: 'repo#repos'
  get 'repos/:repo/issues', to: 'repo#issues', constraints: { repo: /.+/ }
end
