Rails.application.routes.draw do

  devise_scope :user do
    # make some pretty URLs

    get "users/sign_in" => "sessions#new"
    get "users/sign_out" => "sessions#destroy"
    get "users/current_user" => "sessions#get_current_user"
    get "users/dashboard_data" => "users#dashboard_data"

    # rewrite the registrations URLs so they don't collide with my custom Users Controller
    get "signup" => "devise/registrations#new", :as => :new_user_registration
    put "update-registration" => "devise/registrations#update", :as => :update_user_registration
    delete "delete-registration" => "devise/registrations#destroy", :as => :delete_user_registration
    get "edit-registration" => "devise/registrations#edit", :as => :edit_user_registration
    get "cancel-registration" => "devise/registrations#cancel", :as => :cancel_user_registration
    post "create-registration" => "devise/registrations#create", :as => :user_registration
  end

  devise_for :users, controllers: { sessions: "sessions" }

  resources :users
  resources :posts

  get 'get_posts' => 'posts#get_posts'
  post 'create_post' => 'posts#create_post'
  post 'create_post_comment' => 'posts#create_post_comment'
  get 'like_post' => 'posts#like_post'
  get 'unlike_post' => 'posts#unlike_post'

  get 'get_user_stats' => 'users#get_user_stats'
  post 'update_user_stats' => 'users#update_user_stats'

  root :to => 'users#welcome'

end
