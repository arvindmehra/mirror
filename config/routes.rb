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

    get 'users/subscriptions/status' => 'subscriptions#status'
    post 'users/subscriptions/expire_all' => 'subscriptions#expire_all'

    get 'notes/getPS' => "notes#perceptionScore"

    post 'user_activities/record_activity' => "user_activities#record_activity"
    get 'user_activities/active_period' => "user_activities#active_period"

    get "user_activities/keyboard" => "user_activities#keyboard"


    resources :notes
    resources :transactions, only: [:index, :create]
  end

  resources :password_resets, only: [:edit, :update, :create]

end
