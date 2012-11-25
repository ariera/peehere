# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    lat 1
    long 1
    indoor false
    address "MyString"
    description "MyText"
    average "MyText"
  end
end
