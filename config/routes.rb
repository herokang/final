Rails.application.routes.draw do

  get 'index/login', to: "index#loginView"
  get 'index', to: "index#index"
  get 'index/register', to:"index#register"
  post 'index/register',to:"users#create"
  post 'users/new', to: "users#create"
  post 'index/login',to:"index#login"
  get 'index/logout', to:"index#logout"
  get 'students/alllessons',to:"lessons#index"
  post 'lessons/create',to:"lessons#create"
  get 'students/attend', to: "students#attend"
  get 'teachers/exercise',to: "quizs#index"
  get 'students/homeworks',to: "home_works#listQuiz"
  post 'teachers/createQuiz',to:"quizs#create"
  get 'teachers/quizs',to:"quizs#show"
  post 'teachers/createQuestion',to:"questions#create"
  get 'students/questions',to:"home_works#edit"
  get 'students/generateQuestion',to:"home_works#generate"
  post 'students/updateQuestions',to:"home_works#update"
  get 'teachers/publish',to:"quizs#publish"


  root 'index#index'
end
