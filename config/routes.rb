Project::Application.routes.draw do
  match '/:controller/:action'
  root to: 'site#index'
end
