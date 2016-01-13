Rails.application.routes.draw do

  get 'index/login', to: "index#loginView"
  get 'index', to: "index#index"
  get 'index/register'
  post 'users/new', to: "users#create"
  post 'index/login',to:"index#login"
  get 'index/logout'
  get 'students/alllessons',to:"lessons#index"
  post 'lessons/create',to:"lessons#create"
  get 'students/attend', to: "students#attend"

  get 'index/tmpTeacherIndex'

  get 'index/Studenthomework'
  get 'index/Studenthomeworkonline'
  get 'index/StudentCourse'

  get 'index/userlogin', to:"index#userlogin"

  resources :users
  resources :students,:teachers, only:[:show, :edit, :update, :destroy]
  resources :lessons, :quizs

  post 'login', to: "index#login"
  get 'teachers/lessons', to: "teachers#lessons"

  post 'students/exit', to: "students#exit"
  get 'students/lessons', to: "students#lessons"

  post 'add_class', to: "lessons#create"

  root 'index#index'
end
