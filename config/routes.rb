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
  get 'teachers/exercise',to: "quizs#index"
  get 'students/homeworks',to: "home_works#list"
  post 'teachers/createQuiz',to:"quizs#create"



  get 'index/Studenthomework'
  get 'index/Studenthomeworkonline'
  get 'index/StudentCourse'

  root 'index#index'
end
