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
 
    get "users/forgot_password" => "sessions#forgot_password"
  end

  devise_for :users, controllers: { sessions: "sessions",
                                    registrations: "registrations" }

  resources :users
  resources :posts
  resources :events
  resources :event_types

  get 'get_posts' => 'posts#get_posts'
  post 'create_post' => 'posts#create_post'
  post 'create_post_comment' => 'posts#create_post_comment'
  get 'like_post' => 'posts#like_post'
  get 'unlike_post' => 'posts#unlike_post'

  get 'get_user_stats' => 'users#get_user_stats'
  post 'update_user_stats' => 'users#update_user_stats'

  get 'get_current_user' => 'users#get_current_user'
  post 'update_user' => 'users#update_user'

  get 'get_users' => 'users#get_users'

  get 'get_event_statuses' => 'event_statuses#get_event_statuses'
  get 'get_event_types' => 'event_types#get_event_types'

  get 'get_events' => 'events#get_events'
  get 'get_event_dropdowns' => 'events#get_event_dropdowns'

  get 'create_event' => 'events#create_event'
  get 'create_event_comment' => 'events#create_event_comment'

  get 'get_user_details' => 'users#get_user_details'

  resources :messages, only: [:index, :show, :new, :create, :destroy] do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  get 'messages/all/agents' => 'messages#get_all_agents'
  get 'messages/all/managers' => 'messages#get_all_managers'
  get 'messages/:id/read' => 'messages#check_mark_as_read'
  post 'messages/move_checked_to_trash' => 'messages#move_checked_to_trash', as: 'move_checked_to_trash'
  get 'messages/:id/confirm_message' => 'messages#confirm_message'
  get 'confirmation_report' => 'messages#confirmation_report', as: 'message_confirmation_report'
  get 'get_messages' => 'messages#get_messages'
  post 'safe_destroy' => 'messages#safe_destroy', as: 'message_safe_destroy'

  get 'verify_user_login' => 'users#verify_user_login'
  post 'update_all_user_details' => 'users#update_all_user_details'
  post 'update_weapon_stats' => 'weapons#update_weapon_stats'
  post 'update_skin_stats' => 'skins#update_skin_stats'

  get 'leaderboards' => 'users#leaderboards'
  get 'get_leaderboard_data' => 'users#get_leaderboard_data'

  get 'request_friend' => 'users#request_friend'
  get 'remove_friend' => 'users#remove_friend'
  get 'search_users' => 'users#search_users'

  root :to => 'users#welcome'

end
