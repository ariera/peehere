Peehere::Application.routes.draw do

  devise_for :users
  mount RailsAdmin::Engine => '/rails_admin', :as => 'rails_admin'


  

  match 'locations/:id' => 'locations#show', as: 'location'
  #resources :users
  namespace :admin do
    resources :locations do
      collection do
        get :rate
        post :rate
      end
    end
    resources :ratings
  end

  namespace :api, defaults: {format: 'xml'} do
    resources :users
    resources :locations do
      get :search, :on => :collection
      post :rate,    :on => :collection
      #post :comment, :on => :collection
      get  :places,  :on => :collection
    end
  end

  root :to => "home#index"




  #if Rails.env.development?
    mount ApiTaster::Engine => "/api_taster"
    ApiTaster.routes do
      post '/api/users', {
        :name => 'Fred',
        :email => "fred#{Time.now.to_s.gsub(' ','')}@gmail.com",
      }
      put '/api/users/:id', {}

      # post '/api/locations/rate', {
      #   :user_id => 1,
      #   :location => {
      #     :cache_id => 1,
      #     :description => 'Hay millones de arbustos'
      #   },
      #   :ratings => [
      #     {:kind => 'wait',    :value => [true, false].sample },
      #     {:kind => 'pay',     :value => [true, false].sample },
      #     {:kind => 'paper',   :value => [true, false].sample },
      #     {:kind => 'overall', :value => [true, false].sample }
      #   ]
      # }

      # post '/api/locations/rate', {
      #   :user_id => 1,
      #   :location_id => 1,
      #   :ratings => [
      #     {:kind => 'crowded', :value => [true, false].sample },
      #     {:kind => 'hidden',  :value => [true, false].sample },
      #     {:kind => 'safe',    :value => [true, false].sample },
      #     {:kind => 'overall', :value => [true, false].sample }
      #   ]
      # }

      desc 'params [:location =>  [:address, :latitude, :longitude, :indoor => [true, false], :description, :name, :cache_id] ]'
      post '/api/locations/rate', {
        :user_id => 1,
        :location => {
          :cache_id => nil,
          :description => 'Hay millones de arbustos',
          :name => 'La casucha',
          :indoor => false,
          :latitude => 40.401993,
          :longitude => -3.688660,
          :address => nil,          
        },
        :ratings => {
          :'crowded' => [true, false].sample,
          :'hidden'  => [true, false].sample,
          :'safe'    => [true, false].sample,
          :'overall' => [true, false].sample 
        },
      }

      post '/api/locations/rate', {
        :user_id => 1,
        :location => {
          :cache_id => 1,
          :description => 'Esto deberia sobreescribir descripcion',
          :name => 'Y esto el name',
          :comment => "this is a comment",
        },
        :ratings => {
          :'wait'    => [true, false].sample,
          :'pay'     => [true, false].sample,
          :'paper'   => [true, false].sample,
          :'overall' => [true, false].sample 
        }
      }

      
      #post '/api/locations/comment', {
      #  :user_id => 1,
      #  :location_id => 1,
      #  :comment => "this is a comment"
      #}



      #post '/api/locations/rate', {
      #  :user_id => 1,
      #  :location_id => 1,
      #  :ratings => {
      #    :'crowded' => [true, false].sample,
      #    :'hidden'  => [true, false].sample,
      #    :'safe'    => [true, false].sample,
      #    :'overall' => [true, false].sample
      #  }
      #}


      #desc 'params[:address]'
      #get '/api/locations/search', {
      #  address:'Gran Via 32, Madrid'
      #}

      desc 'params [:address]'
      get '/api/locations/search', {
        address: 'Gran Via 32, Madrid'
      }

      desc 'params [:address, :latitude, :longitude, :show => [:indoor, :outdoor, :all], :distance]'
      get '/api/locations', {
        latitude: 40.4238, 
        longitude: -3.7071,
        show: 'all',
      }

      get '/api/locations', {
        address: 'Gran Via 32, Madrid',
        show: 'all'
      }

      get '/api/locations/:id', {:id => 1}

      desc "params[:latitude, :longitude, :address, :name]"
      get '/api/locations/places', {
        latitude:  40.4238, 
        longitude: -3.7071,        
      }
    end
  #end #if
end
