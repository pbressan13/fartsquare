# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require_relative "db/parse_coordinates_csv"

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

name = places.map(&:name)
lat = places.map(&:lat)
lng = places.map(&:lng)
full_address = places.map(&:formatted_address)
phone_number = places.map(&:formatted_phone_number)
google_id = places.map(&:place_id)
business_status = places.map { |p| p.json_result_object["business_status"] }
address_components = places.map { |p| p.json_result_object["address_components"] }

city = []
federal_unity = []

address_components.each do |component|
  component.each do |c|
    if c["types"].include?("administrative_area_level_1")
      federal_unity << c["short_name"]
    elsif c["types"].include?("administrative_area_level_2")
      city << c["long_name"]
    else
      "Error"
    end
  end
end

# Ideia para a sequencia:
# places.flatten para ter o conjunto completo de locais
# para pegar fotos de um local específico:
# places.first.photos[0].fetch_url(800)
