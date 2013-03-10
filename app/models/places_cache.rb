class PlacesCache < ActiveRecord::Base
  attr_accessible :address_components, :formatted_address, :formatted_phone_number, :icon, :international_phone_number, :latitude, :longitude, :name, :reference, :types, :vicinity

  PLACES_TO_PEE = ['bar', 'night_club', 'cafe', 'restaurant', 'bus_station', 'casino', 'church', 'courthouse', 'gas_station', 'laundry', 'library', 'lodging']

  def self.find_places(params)
    lat, long = params[:latitude], params[:longitude]
    if params[:address]
      loc = Location.new(params[:address])
      lat, long = loc.geocode
    end
    places = GPlaces.spots(lat, long, :name => params[:name])
    caches = PlacesCache.persist_search(places)
    self.to_location(caches)
  end

  def self.persist_search(places)
    attrs = ["reference", "vicinity", "name", "icon", "types", "formatted_phone_number", "international_phone_number", "formatted_address", "address_components", "street_number", "street", "city", "region", "postal_code", "country", "rating", "url", "cid", "website" ]
    places_caches = []
    places.each do |place|
      if cache = self.where(:google_place_id => place.id).first
        places_caches << cache
        next
      end
      
      places_caches << PlacesCache.create do |cache|
        attrs.each{ |a| cache.send("#{a}=", place.send(a)) }
        cache.latitude  = place.lat
        cache.longitude = place.lng
        cache.google_place_id = place.id
      end
    end
    places_caches
  end

  def self.to_location(caches)
    caches.map{ |cache| cache.to_location }
  end

  def to_location
    Location.new({
      cache_id: self.id,
      latitude: self.latitude,
      longitude: self.longitude,
      address: self.vicinity,
      indoor: true,
      name: self.name
    })
  end
end
