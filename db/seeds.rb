# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require_relative 'db/parse_coordinates_csv'

file_path = 'db/SP_COORDINATES_SEED_ESTABLISHMENT.csv'

coordinates = gather_coordinates(file_path)

@client = GooglePlaces::Client.new(ENV['PLACES_API'])

places = []

coordinates.first(1).each do |coordinate|
  places << @client.spots(
    coordinate[:lat], coordinate[:lng],
    types: ['food', 'gas_station'],
    radius: 60_000,
    detail: true
  )
end

places.flatten!

def service_intervals(places)
  opening_hours = places.map { |place| place['opening_hours'] }

  availability = []

  opening_hours.each do |oh|
    if oh.nil?
      availability << nil
    else
      availability << oh["weekday_text"]
    end
  end
end

def location(places)
  city = []
  federal_unity = []

  address_components = places.map { |place| place.json_result_object['address_components'] }

  address_components.each do |component|
    component.each do |c|
      if c['types'].include?('administrative_area_level_1')
        federal_unity << c['short_name']
      elsif c['types'].include?('administrative_area_level_2')
        city << c['long_name']
      else
        'Error'
      end
    end
  end
end

name = places.map(&:name)
lat = places.map(&:lat)
lng = places.map(&:lng)
full_address = places.map(&:formatted_address)
phone_number = places.map(&:formatted_phone_number)
google_id = places.map(&:place_id)
business_status = places.map { |place| place.json_result_object['business_status'] }

service_intervals(places) # availability
location(places) # city e federal_unity

# Ideia para a sequencia:
# places.flatten para ter o conjunto completo de locais
# para pegar fotos de um local específico:
# places.first.photos[0].fetch_url(800)

# ['Monday: 6:00 AM – 10:00 PM',
#  'Tuesday: 6:00 AM – 10:00 PM',
#  'Wednesday: 6:00 AM – 10:00 PM',
#  'Thursday: 6:00 AM – 10:00 PM',
#  'Friday: 6:00 AM – 10:00 PM',
#  'Saturday: 6:00 AM – 10:00 PM',
#  'Sunday: 6:00 AM – 10:00 PM']

#  User.create(email: 'teste@teste.com', password: 'testeteste')

#  e = Establishment.new

#  e.user_id = User.first.id
