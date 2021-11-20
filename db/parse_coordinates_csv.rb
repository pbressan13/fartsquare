require 'csv'

def gather_coordinates(file_path, number_points, shuffle = true)
  header = %i[lng lat]
  csv_options = { col_sep: ',', headers: header }

  coordinates = []

  CSV.foreach(file_path, csv_options) do |row|
    coordinates << row.to_h
  end

  coordinates.each { |h| h.each_pair { |k, v| h[k] = v.to_f } }

  if shuffle == true
    coordinates.shuffle!
  else
    coordinates
  end

  return coordinates.first(number_points)
end
