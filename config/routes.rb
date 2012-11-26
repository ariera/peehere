Peehere::Application.routes.draw do

  resources :users
  resources :locations
  resources :ratings

  namespace :api, defaults: {format: 'xml'} do
    resources :users
    resources :locations do
      post :rate, :on => :collection
      get  :places, :on => :collection
    end
  end

  mount ApiTaster::Engine => "/api_taster" if Rails.env.development?
  root :to => "home#index"




  if Rails.env.development?
    ApiTaster.routes do
      post '/api/users', {
        :name => 'Fred',
        :email => "fred#{Time.now.to_s.gsub(' ','')}@gmail.com",
      }

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

      post '/api/locations/rate', {
        :user_id => 1,
        :location => {
          :cache_id => 1,
          :description => 'Hay millones de arbustos'
        },
        :ratings => {
          :'wait'    => [true, false].sample,
          :'pay'     => [true, false].sample,
          :'paper'   => [true, false].sample,
          :'overall' => [true, false].sample 
        }
      }

      post '/api/locations/rate', {
        :user_id => 1,
        :location_id => 1,
        :ratings => {
          :'crowded' => [true, false].sample,
          :'hidden'  => [true, false].sample,
          :'safe'    => [true, false].sample,
          :'overall' => [true, false].sample
        }
      }


      desc 'params [:address, :latitude, :longitude, :show => [:indoor, :outdoor, :all], :distance]'
      get '/api/locations', {
        latitude: 40.4238, 
        longitude: -3.7071,
        show: 'all',
      }

      get '/api/locations/:id', {:id => 1}

      desc "params[:latitude, :longitude, :address, :name]"
      get '/api/locations/places', {
        latitude:  40.4238, 
        longitude: -3.7071,        
      }
    end
  end
end
