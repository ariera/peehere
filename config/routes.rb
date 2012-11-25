Peehere::Application.routes.draw do

  namespace :api, defaults: {format: 'xml'} do
    resources :users
    resources :locations do
      post :rate, :on => :collection
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

      post '/api/locations/rate', {
        :user_id => 1,
        :location => {
          :address => 'Cruz Verde 16, Madrid, 28004',
          :indoor => true,
          :name => 'El Bonar de Leon'
        },
        :ratings => [
          {:kind => 'wait',    :value => [true, false].sample },
          {:kind => 'pay',     :value => [true, false].sample },
          {:kind => 'paper',   :value => [true, false].sample },
          {:kind => 'overall', :value => [true, false].sample }
        ]
      }

      post '/api/locations/rate', {
        :user_id => 1,
        :location_id => 1,
        :ratings => [
          {:kind => 'wait',    :value => [true, false].sample },
          {:kind => 'pay',     :value => [true, false].sample },
          {:kind => 'paper',   :value => [true, false].sample },
          {:kind => 'overall', :value => [true, false].sample }
        ]
      }
      get '/api/locations'
      get '/api/locations/:id', {:id => 1}
    end
  end
end
