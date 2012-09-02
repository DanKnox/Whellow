Whellow::Application.routes.draw do
  match '/auth/singly/callback' => 'site#callback'
  match '/:controller/:action'
  match '/:action' => 'site'
  root to: 'site#index'
end
