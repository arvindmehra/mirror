Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  api_version(:module => "V1", :path => {:value => "v1"}) do

    resources :users, only: [:index, :create] do
      collection do
        get 'me' => 'users#show'
        patch 'me' => 'users#update'
        post 'sign_in' => 'users#sign_in'
        post 'sign_out' => 'users#sign_out'
        post 'password_resets' => 'users#create_password_reset'
        resources :subscriptions, only: [:index, :create]
      end
    end

    get 'tags/search' => "tags#search"
    get 'tags' => "tags#index", :defaults => {:format => 'json'}

    get 'devices/me' => 'devices#show'
    patch 'devices/me' => 'devices#update'
    patch 'devices/set_notification_token' => 'devices#set_notification_token'

    get 'users/subscriptions/status' => 'subscriptions#status'
    post 'users/subscriptions/expire_all' => 'subscriptions#expire_all'

    get 'notes/getPS' => "notes#perceptionScore"

    post 'user_activities/record_activity' => "user_activities#record_activity"
    post 'user_activities/set_activity_goal' => "user_activities#set_activity_goal"

    get 'user_activities/active_period' => "user_activities#active_period"
    get "user_activities/keyboard" => "user_activities#keyboard"

    get "user_notifications/get_all" => "user_notifications#get_all"
    get "user_notifications/template" => "user_notifications#template"

    resources :user_notifications, :only => [:update] do 
      collection do
        get :get_unread_count
      end
    end
    resources :notes
    resources :transactions, only: [:index, :create]
  end
  
  resources :filters do 
    collection do
      get :get_list
      get :get_collective_list
      get :get_segments
    end
  end
  get 'temp_push_notifications/get_push' => 'temp_push_notifications#get_push' #temp url
  resources :notification_templates do
    collection do
      get :blast_send
      patch :deactivate
      patch :activate
      get :get_list
    end
    member do 
      post :duplicate_me
    end
  end
  resources :filter_groups do
    member do
      post :duplicate_me
    end
  end
  resources :rule_engines do
    member do
      post :duplicate_me
    end
  end
  resources :password_resets, only: [:edit, :update, :create]

end
