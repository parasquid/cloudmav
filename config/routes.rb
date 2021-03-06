Codemav::Application.routes.draw do
  match 'points' => 'pages#points', :as => :points
  
  namespace "admin", :as => :admin do
    match "typography" => "pages#typography", :as => :typography
    match "form" => "pages#form", :as => :form    
  end
  
  namespace "api/v1", :as => :api do
    resources :profiles do
      member do
        get :tags
      end
    end
  end
  
  devise_for :users do
    get "confirmation", :to => "devise/users#confirmation"
    get "login", :to => "devise/sessions#new"
    get 'logout', :to => "devise/sessions#destroy"
  end
  
  resources :profiles do
    resource :activity
    resource :syncable
    resource :autodiscover
    resource :points_summary
    
    # basic resources
    resource :speaking
    resource :writing
    resource :experience
    resource :knowledge
    resource :code
    resource :social
    
    resources :git_hub_profiles
    resources :bitbucket_profiles
    resources :coder_wall_profiles
    resources :stack_overflow_profiles
    resources :speaker_rate_profiles
    resources :slide_share_profiles
    resources :followings
    resources :speaker_bios
    resources :blogs
    resources :linkedin_profiles
    resources :jobs
    resources :twitter_profiles
    resources :talks do
      resource :link_to_git_hub_repository
      resource :link_to_bitbucket_repository      
      resource :link_to_speaker_rate do
        member do
          get :refresh
        end
      end
      resource :link_to_slide_share do
        member do
          get :refresh
        end
      end
    end
    resources :linkedin_profiles do
      member do
        get :callback
        post :confirm
      end
      # collection do
      #   get :callback
      #   post :confirm
      # end
    end
    collection do
      post :search
    end
  end
  
  resources :companies
  
  resources :contacts
  match 'contact' => 'contacts#new', :as => :contact
  
  resource :talk_search
  
  mount Resque::Server, :at => "/resque"  

  match "/change_log" => "pages#change_log", :as => :change_log

  match "/:username" => "profiles#show", :as => :profile
  match "/:username/update" => "profiles#update", :as => :update_profile, :method => :put
  match "/:username/experience" => "experiences#show", :as => :profile_experience
  match "/:username/code" => "codes#show", :as => :profile_code
  match "/:username/knowledge" => "knowledges#show", :as => :profile_knowledge
  match "/:username/writing" => "writings#show", :as => :profile_writing
  match "/:username/speaking" => "speakings#show", :as => :profile_speaking
  match "/:username/social" => "socials#show", :as => :profile_social
  
  root :to => "pages#home"
end
