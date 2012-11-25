# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    user_id 1
    location_id 1
    comment "MyText"
    type ""
    value false
  end
end
