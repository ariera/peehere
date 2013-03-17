class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  attr_accessible :body, :location_id, :user_id

  #def to_xml(options={})
  #  options.merge!(:except => [:created_at, :updated_at, :id, :location_id, :user_id], :methods => :user_name)
  #  super(options)
  #end

  def to_html
    "<strong>#{user_name.split("@")[0]}: </strong> #{body}"
  end

  def user_name
    user.name
  end
end
