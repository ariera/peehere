# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :places_cach, :class => 'PlacesCache' do
    reference "MyText"
    vicinity "MyString"
    latitude 1.5
    longitude 1.5
    name "MyString"
    icon "MyString"
    types "MyText"
    formatted_phone_number "MyString"
    international_phone_number "MyString"
    formatted_address "MyString"
    address_components "MyString"
  end
end
