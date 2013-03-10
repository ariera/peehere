url_options = {
  'development' => {:host => "localhost", :port=>8080},
  'test'        => {:host => "localhost"},
  'production'  => {:host => 'peehere.herokuapp.com'}
}

ActionMailer::Base.default_url_options = url_options[Rails.env]
Rails.application.routes.default_url_options = url_options[Rails.env]
