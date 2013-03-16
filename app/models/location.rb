# encoding: UTF-8
class Location < ActiveRecord::Base
  has_many :ratings
  has_many :comments
  #attr_accessor :cache_id
  attr_accessible :address, :average, :description, :indoor, :latitude, :longitude, :name, :cache_id
  serialize :average, Hash
  geocoded_by :address
  # FIXME: sometimes google times out when reverse geocoding, we should retry
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode_or_reverse_geocode

  DEFAULT_DISTANCE = 1 #in km
  DEFAULT_LIMIT = 10 # return 10 results at most
  VALID_RATINGS_FOR_INDOORS =  [:pay, :wait, :paper, :overall]
  VALID_RATINGS_FOR_OUTDOORS = [:crowded, :hidden, :safe, :overall]

  def self.get_cached_ids
    self.where('cache_id IS NOT NULL').select(:cache_id).map(&:cache_id)
  end

  def self.find_or_create(params)
    if params[:location_id].present?
      Location.find(params[:location_id])
    elsif params[:location][:cache_id].present?
      loc = PlacesCache.find(params[:location][:cache_id]).to_location
      loc.attributes = params[:location]
      loc.save
      loc
    else
      Location.create(params[:location])
    end
  end

  def self.find_by_address_or_coords_and_filter(params)
    locations = Location.scoped
    locations = locations.where(:indoor => true) if params[:show].to_s == 'indoor'
    locations = locations.where(:indoor => false) if params[:show].to_s == 'outdoor'

    near_what = params[:address] if params[:address].present?
    near_what = [params[:latitude], params[:longitude]] if params[:latitude].present? 

    locations = locations.near(near_what, params[:distance] || DEFAULT_DISTANCE)
    locations = locations.order('distance')
    locations = locations.limit(params[:limit] || DEFAULT_LIMIT)
  end

  def update_statistics!
    self.update_average
    self.update_people_count
    # FIXME: a save in this model might trigger a geocode or reverse_geocode call to Google
    # this should be avoided
    self.save
  end

  def update_people_count
    # self.people_count = self.ratings.group(:user_id).length
    self.people_count = self.ratings.select('ratings.id, ratings.user_id').group_by(&:user_id).length
  end

  def update_average
    if self.indoor?
      self.average = calculate_indoor_average
    else
      self.average = calculate_outdoor_average
    end
  end

  def calculate_indoor_average
    {
      pay:     Rating.average_for_kind('pay',     self.id),
      wait:    Rating.average_for_kind('wait',    self.id),
      paper:   Rating.average_for_kind('paper',   self.id),
      overall: Rating.average_for_kind('overall', self.id)
    }
  end

  def calculate_outdoor_average
    {
      crowded: Rating.average_for_kind('crowded', self.id),
      hidden:  Rating.average_for_kind('hidden',  self.id),
      safe:    Rating.average_for_kind('safe',    self.id),
      overall: Rating.average_for_kind('overall', self.id)
    }
  end

  def geocode_or_reverse_geocode
    if address
      geocode
    else
      reverse_geocode
    end
  end

  #def valid_ratings?(params)
  #  if self.indoor?
  #    params.all?{ |rating| VALID_RATINGS_FOR_INDOORS.include?(rating[:kind].to_sym) }
  #  else
  #    params.all?{ |rating| VALID_RATINGS_FOR_OUTDOORS.include?(rating[:kind].to_sym) }
  #  end
  #end

  def valid_ratings?(params)
    return true if params.blank?
    if self.indoor?
      params.keys.all?{ |kind| VALID_RATINGS_FOR_INDOORS.include?(kind.to_sym) }
    else
      params.keys.all?{ |kind| VALID_RATINGS_FOR_OUTDOORS.include?(kind.to_sym) }
    end    
  end

  def to_xml(options={})
    super(options.merge(include: :comments))
  end
  
  def to_tweet
    url = Rails.application.routes.url_helpers.location_url(self)
    url = 'http://pee-here.com'
    "http://twitter.com/home?status=#{random_tweet} #{CGI::escape(url)} @peehere"
  end

  def random_tweet
    @@possible_tweets.sample
  end
  @@possible_tweets = [
    "Don't worry, pee happy",
    "Orina como en casa",
    "Orina en publico como si estuvieses en casa",
    "Llego la aplicación móvil para que orines donde mas te guste.",
    "Orina a domicilio", 
    "Pee Here. Orina donde quieras",
    "Psssss. Necesitas ir al baño? Pee Here esta desocupado",
    "Te estas orinando? Pee Here te echa una mano",
    "Ven a orinar con nosotros",
    "Lugares orinables full time",
    "Si te estas por mear, meate con nosotros",
    "Orina aquí. Y ahí. Tambien allí",
    "Libera la orina que llevas en ti",
    "Tenemos el lugar indicado para que satisfagas tus necesidades",
    "En apuros? Lo siento", 
    "En Pee Here sabemos donde hay papel higienico",
    "No esperes, Pee Here",
    "You’ll never pee alone",
    "Programa tu orina",
    "Support your team with our app",
    "In peeing we believe",
    "Te estas meando? Vete al baño",
    "Pee Here: mobile bathrooms",
    "Te damos un chocolate por cada descarga",
    "Pruebanos  y si no te convence te devolvemos la orina sin ningún cargo",
    "Si descargas Pee Here te comentaremos las fotos del Facebook que menos feedback hayan tenido",
    "Te queremos. Ver mear",
    "Velamos por la seguridad de tu orina",
    "Para cuando tengas necesidades en la calle, Pee Here",
    "Pee here te evita infecciones de orina",
    "Seis de cada diez personas recomienda que “orinar” es saludable. Somos mayoría.",
    "Esto es una dictadura: te obligamos a que orines en uno (o todos) nuestros lugares públicos.",
    "Tu novio te engaña? Ok, solo por esta vez te dejamos que nos cambies: Pee on Him.",
    "Vente de gira con Pee Here. Haremos botellón en el lugar publico mas votado",
    "Si te estas orinando, nos querras en tus manos",
    "Antes de mear necesitaras saber el lugar",
    "Si nuestra App no te sirve, vendemos papel higienico o te prestamos un Kleenex a un euro",
    "Ya sabes el lugar, solo dale a “Confirmar”",
    "Porque el bano es el espacio mas intimo, Pee Here te hace de mejor amigo o de momento reflexivo",
  ]



end
