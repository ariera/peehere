Geocoder.configure do |config|

  # to use an API key:
  # config.api_key = "AIzaSyCuo6A7t-4cjMjbIh48oCgLFACPyykvAQM"

  # geocoding service request timeout, in seconds (default 3):
  config.timeout = 5

  # set default units to kilometers:
  config.units = :km

  # caching (see below for details):
  #config.cache = Redis.new
  #config.cache_prefix = "..."

end
