class UserRatesALocation
  include RolePlaying::Context

  attr_reader :user, :params, :ratings_params
  def initialize(user, params)
    @user = user
    @params = params
    @ratings_params = params[:ratings]
    @loc = find_or_initialize_location(params)
  end

  def call
    return loc unless validates && location.save
    Rateable.new(user).create_ratings(loc, params[:ratings])
    Statisticable.new(loc)
    loc
  end

  role :Rateable do
    def create_ratings(loc, params)
      raise unless loc.valid_ratings?(params)
      return if params.blank?
      ratings = []
      params.each do |k,v|
        ratings << self.ratings.create do |r|
          r.location_id = loc.id
          r.kind  = k
          r.value = v
        end
      end
      ratings
    end
  end

  role :Statisticable do

    def update_statistics!
      self.update_average
      self.update_people_count
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

  end

  def find_or_initialize_location(params)
    if params[:location_id]
      Location.find(params[:location_id]) 
    elsif params[:location][:cache_id]
      PlacesCache.find(params[:location][:cache_id]).to_location
    else
      Location.new(params[:location])
    end 
  end

  def validate!
    if ! valid_ratings?
      loc.errors[:ratings] = "Please provide at least one rating"   
      return false
    else
      return true
    end
  end

  def valid_ratings?
    return true if ratings_params.blank?
    if self.indoor?
      params.keys.all?{ |kind| VALID_RATINGS_FOR_INDOORS.include?(kind.to_sym) }
    else
      params.keys.all?{ |kind| VALID_RATINGS_FOR_OUTDOORS.include?(kind.to_sym) }
    end  
  end


end
