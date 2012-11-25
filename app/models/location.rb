class Location < ActiveRecord::Base
  has_many :ratings
  attr_accessible :address, :average, :description, :indoor, :lat, :long, :name
  serialize :average, Hash

  def self.find_or_create(params)
    if params[:location_id]
      Location.find(params[:location_id]) 
    else
      Location.create(params[:location])
    end
  end

  def update_average!
    if self.indoor?
      self.average = calculate_indoor_average
    else
      self.average = calculate_outdoor_average
    end
    self.save
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
end
