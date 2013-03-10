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
  
  def self.find_or_create(params)
    user = find_by_email(params[:email])
    return user if user
    create do |u|
      if params[:name].blank?
        u.name =  params[:email].split('@').first + '@' + Devise.friendly_token[0,6]
      else
        u.name = params[:name]
      end
      u.email = params[:email]
      u.password = Devise.friendly_token[0,20]
    end
  end

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

  def is_admin?
    %w{wepeehere@gmail.com ariera@gmail.com}.include? self.email
  end
end
