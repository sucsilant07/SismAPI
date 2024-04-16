namespace :obtener_datos_sismologicos do
  desc "Obtener y persistir datos sismológicos desde USGS"
  task obtener_y_persistir: :environment do
    require 'httparty'
    require 'json'

    response = HTTParty.get('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')

    if response.code == 200
      data = JSON.parse(response.body)
      puts "Datos obtenidos correctamente:"

      # Procesamiento y persistencia de los datos
      data['features'].each do |feature|
        event_params = {
          external_id: feature['id'],
          magnitude: feature['properties']['mag'],
          place: feature['properties']['place'],
          time: Time.at(feature['properties']['time'] / 1000).to_datetime.to_s,
          url: feature['properties']['url'],
          tsunami: !!feature['properties']['tsunami'],
          mag_type: feature['properties']['magType'],
          title: feature['properties']['title'],
          longitude: feature['geometry']['coordinates'][0],
          latitude: feature['geometry']['coordinates'][1]
        }
        EarthquakeEvent.create(event_params)
      end
    else
      puts "Error al obtener los datos: #{response.code}"
    end
  end
end
