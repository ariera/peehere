class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :ratings
  has_many :comments

  attr_accessible :name, :email
  validates :name, presence:true
  validates :email, presence:true 

  #def create_ratings(loc, params)
  #  raise unless loc.valid_ratings?(params)
  #  ratings = []
  #  params.each do |param|
  #    ratings << self.ratings.create do |r|
  #      r.location_id = loc.id
  #      r.kind  = param[:kind]
  #      r.value = param[:value]
  #    end
  #  end
  #  ratings
  #end
  
  def create_ratings(loc, params)
    raise unless loc.valid_ratings?(params)
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

  def is_admin?
    %w{nosecreoque@gmail.com ariera@gmail.com}.include? self.email
  end
end
