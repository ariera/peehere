class Rating < ActiveRecord::Base
  belongs_to :user

  attr_accessible :location_id, :user_id, :kind, :value
  def self.average_for_kind(kind, location_id)
    ratings = self.where(location_id:location_id, kind:kind)
    value = ratings.select{|r| r.value}.count.to_f / ratings.count.to_f
    return value if kind.to_s == 'overall'

    # this a bizarre way to convert percentage to 5 stars rating
    5.times{|i| return (i+1).to_f if 1/5.to_f * (i+1) >= value }
  end
end
