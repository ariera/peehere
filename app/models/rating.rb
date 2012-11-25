class Rating < ActiveRecord::Base
  belongs_to :user

  def self.average_for_kind(kind, location_id)
    ratings = self.where(location_id:location_id, kind:kind)
    ratings.select{|r| r.value}.count.to_f / ratings.count.to_f
  end
end
