class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :location

  attr_accessible :location_id, :user_id, :kind, :value
  def self.average_for_kind(kind, location_id)
    ratings = self.where(location_id:location_id, kind:kind)
    value = ratings.select{|r| r.value}.count.to_f / ratings.count.to_f
    value = 1.0 if value.nan? && kind.to_s == 'overall'
    return value if kind.to_s == 'overall'

    self.convert_to_five_star_rating(kind, value)
  end

  def self.average_of(kind, ratings)
    return 0.0 if ratings.blank?
    value = case kind.to_sym
    when :pay, :wait, :crowded
      # it is a good thing not having to pay, wait, or choosing a not crowded place to pee
      ratings.select{|r| !r.value}
    else # paper hidden safe overall
      # on the other hand a bathroom with paper or a hidden spot are considered good things
      ratings.select{|r| r.value}
    end.count.to_f / ratings.count.to_f
  end

  def self.convert_to_five_star_rating(kind, value)
    # this a bizarre way to convert percentage to 5 stars rating
    #debugger if kind=='hidden'
    five_star_rating = 5.times{|i| return (i+1).to_f if 1/5.to_f * (i.to_f+1.0) >= value }
    case kind.to_sym
    when :pay, :wait, :crowded
      self.invert_five_star_rating(five_star_rating)
    else
      five_star_rating
    end
  end

  def self.invert_five_star_rating(five_star_rating)
    6.0 - five_star_rating
  end
end
