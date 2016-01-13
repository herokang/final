Rails.application.routes.draw do

  get 'index/login'
  post 'index/login',to:"index#login"
  get 'index/register'
  post 'users/new',to:"users#create"

  get 'index/tmpTeacherIndex'
  get 'index', to: "index#index"

  get 'index/Studenthomework'
  get 'index/Studenthomeworkonline'
  get 'index/StudentCourse'

  get 'index/userlogin', to:"index#userlogin"

  resources :users
  resources :students,:teachers, only:[:show, :edit, :update, :destroy]
  resources :lessons, :quizs

  post 'login', to: "index#login"
  get 'teachers/lessons', to: "teachers#lessons"

  post 'students/attend', to: "students#attend"
  post 'students/exit', to: "students#exit"
  get 'students/lessons', to: "students#lessons"

  root 'index#index'
end
