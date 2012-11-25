class User < ActiveRecord::Base
  has_many :ratings

  attr_accessible :name, :email
  validates :name, presence:true
  validates :email, presence:true 

  def create_ratings(loc, params)
    ratings = []
    params.each do |param|
      ratings << self.ratings.create do |r|
        r.location_id = loc.id
        r.kind  = param[:kind]
        r.value = param[:value]
      end
    end
    ratings
  end
end
