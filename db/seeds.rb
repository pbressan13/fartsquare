# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Bathroom.destroy_all
Establishment.destroy_all
User.destroy_all

25.times do
  User.create(
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    name: Faker::Name.name
  )
end

require_relative 'parse_coordinates_csv'

file_path = 'db/SP_COORDINATES_SEED_ESTABLISHMENT.csv'

coordinates = gather_coordinates(file_path, 5, false)

@client = GooglePlaces::Client.new(ENV['PLACES_API'])

places = []

coordinates.each do |coordinate|
  places << @client.spots(
    coordinate[:lat], coordinate[:lng],
    types: %w[restaurant gas_station convenience_store],
    radius: 10_000,
    detail: true
  )
end

places.flatten!

name = places.map(&:name)
lat = places.map(&:lat)
lng = places.map(&:lng)
full_address = places.map(&:formatted_address)
phone_number = places.map(&:formatted_phone_number)
google_id = places.map(&:place_id)
types = places.map(&:types)
business_status = places.map { |place| place.json_result_object['business_status'] }
photo_link = places.map { |place| place.photos.first.fetch_url(800) unless place.photos.first.nil? }
address_components = places.map { |place| place.json_result_object['address_components'] }

def get_service_intervals(places)
  availability = []

  opening_hours = places.map { |place| place['opening_hours'] }

  opening_hours.each do |oh|
    if oh.nil?
      availability << nil
    else
      availability << oh['weekday_text']
    end
  end
  availability
end

def get_federal_unity(address_components)
  federal_unity = []

  if address_components.nil?
    federal_unity << nil
  else
    address_components.each do |type|
      type.each do |c|
        federal_unity << c['short_name'] if c['types'].include?('administrative_area_level_1')
      end
    end
  end
  return federal_unity
end

def get_city(address_components)
  city = []

  if address_components.nil?
    city << nil
  else
    address_components.each do |type|
      type.each do |c|
        city << c['long_name'] if c['types'].include?('administrative_area_level_2')
      end
    end
  end
  return city
end

availability = get_service_intervals(places) # availability
federal_unity = get_federal_unity(address_components) # federal_unity
city = get_city(address_components) # city

places.count.times do |i|
  Establishment.create!(
    user_id: User.all.sample.id,
    city: city[i],
    federal_unity: federal_unity[i],
    name: name[i].nil? ? '' : name[i],
    full_address: full_address[i].nil? ? '' : full_address[i],
    phone_number: phone_number[i].nil? ? '' : phone_number[i],
    lat: lat[i],
    lng: lng[i],
    google_id: google_id[i],
    business_status: business_status[i].nil? ? '' : business_status[i],
    photo_link: photo_link[i].nil? ? '' : photo_link[i],
    availability: availability[i].nil? ? [] : availability[i],
    types: types[i].nil? ? [] : types[i]
  )
end

def t_or_f
  [true, false].sample(1).pop
end

Establishment.count.times do
  Bathroom.create!(
    establishment_id: Establishment.first.id + 1,
    tomada: t_or_f,
    internet: t_or_f,
    papel_premium: t_or_f,
    chuveirinho: t_or_f
  )
end

# ['Monday: 6:00 AM – 10:00 PM',
#  'Tuesday: 6:00 AM – 10:00 PM',
#  'Wednesday: 6:00 AM – 10:00 PM',
#  'Thursday: 9:30 AM – 10:00 PM',
#  'Friday: 6:00 AM – 10:00 PM',
#  'Saturday: 6:00 AM – 10:00 PM',
#  'Sunday: 6:00 AM – 10:00 PM']

#  User.create(email: 'teste@teste.com', password: 'testeteste')

#  e = Establishment.new

#  e.user_id = User.first.id
