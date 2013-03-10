class Location < ActiveRecord::Base
  has_many :ratings
  has_many :comments
  attr_accessor :cache_id
  attr_accessible :address, :average, :description, :indoor, :latitude, :longitude, :name, :cache_id
  serialize :average, Hash
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode_or_reverse_geocode

  DEFAULT_DISTANCE = 1 #in km
  VALID_RATINGS_FOR_INDOORS =  [:pay, :wait, :paper, :overall]
  VALID_RATINGS_FOR_OUTDOORS = [:crowded, :hidden, :safe, :overall]

  def self.find_or_create(params)
    if params[:location_id]
      Location.find(params[:location_id]) 
    elsif params[:location][:cache_id]
      loc = PlacesCache.find(params[:location][:cache_id]).to_location
      loc.save
      loc
    else
      Location.create(params[:location])
    end
  end

  def self.find_by_address_or_coords_and_filter(params)
    locations = Location.scoped
    locations = locations.where(:indoor => true) if params[:show] == 'indoor'
    locations = locations.where(:indoor => false) if params[:show] == 'outdoor'

    near_what = params[:address] if params[:address].present?
    near_what = [params[:latitude], params[:longitude]] if params[:latitude].present? 

    locations.near(near_what, params[:distance] || DEFAULT_DISTANCE)
  end

  def update_statistics!
    self.update_average
    self.update_people_count
    self.save
  end

  def update_people_count
    self.people_count = self.ratings.group(:user_id).length
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
    if self.indoor?
      params.keys.all?{ |kind| VALID_RATINGS_FOR_INDOORS.include?(kind.to_sym) }
    else
      params.keys.all?{ |kind| VALID_RATINGS_FOR_OUTDOORS.include?(kind.to_sym) }
    end    
  end

  def to_xml(options={})
    super(options.merge(include: :comments))
  end




end
