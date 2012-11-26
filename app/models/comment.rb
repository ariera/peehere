class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  attr_accessible :body, :location_id, :user_id
end
