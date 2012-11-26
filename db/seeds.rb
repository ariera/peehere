u=User.create(:name => "desio", :email => "desio@gmail.com")
1.upto(10) do |i|
  l = Location.create(:address => "Gran Via #{i}, Madrid", indoor:false)
  Rating.create(location_id:l.id, user_id:u.id, kind:'hidden', value:[true,false].sample)
  Rating.create(location_id:l.id, user_id:u.id, kind:'crowded', value:[true,false].sample)
  Rating.create(location_id:l.id, user_id:u.id, kind:'safe', value:[true,false].sample)
  Rating.create(location_id:l.id, user_id:u.id, kind:'overall', value:[true,false].sample)
  l.update_statistics!
end

11.upto(20) do |i|
  l = Location.create(:address => "Gran Via #{i}, Madrid", indoor:true)
  Rating.create(location_id:l.id, user_id:u.id, kind:'pay', value:[true,false].sample)
  Rating.create(location_id:l.id, user_id:u.id, kind:'wait', value:[true,false].sample)
  Rating.create(location_id:l.id, user_id:u.id, kind:'paper', value:[true,false].sample)
  Rating.create(location_id:l.id, user_id:u.id, kind:'overall', value:[true,false].sample)
  l.update_statistics!
end
