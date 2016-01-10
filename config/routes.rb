Rails.application.routes.draw do
  get 'index/index'

  get 'index/login'

  get 'index/register'

  get 'report/index'

  resources :users
  resources :students,:teachers, only:[:show, :edit, :update, :destroy]
  resources :lessons, :quizs

  post 'login', to: "users#login"
  get 'teachers/lessons', to: "teachers#lessons"

  post 'students/attend', to: "students#attend"
  post 'students/exit', to: "students#exit"
  get 'students/lessons', to: "students#lessons"

  root 'index#index'
end
