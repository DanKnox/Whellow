Whellow::Application.routes.draw do
  match '/auth/:provider/callback' => 'site#callback'
  match '/:controller/:action'
  match '/:action' => 'site'
  root to: 'site#index'
end
