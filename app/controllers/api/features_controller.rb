module Api
  class FeaturesController < ApplicationController
    def index
      features = filter_features(params)
      render json: serialize_features(features), status: :ok
    end

    private

    def filter_features(params)
      features = EarthquakeEvent.all

      # Filtrar por mag_type si se proporciona
      if params[:filters] && params[:filters][:mag_type]
        features = features.where(mag_type: params[:filters][:mag_type])
      end

      # Paginar los resultados si se proporciona page y per_page
      page = (params[:page] || 1).to_i.positive? ? (params[:page] || 1).to_i : 1
      per_page = (params[:per_page].to_i.positive? ? params[:per_page].to_i : 1000)
      features = features.paginate(page: page, per_page: per_page)

      features
    end

    def serialize_features(features)
      features.map do |feature|
        {
          id: feature.id,
          type: 'feature',
          attributes: {
            external_id: feature.external_id,
            magnitude: feature.magnitude,
            place: feature.place,
            time: feature.time,
            tsunami: feature.tsunami,
            mag_type: feature.mag_type,
            title: feature.title,
            coordinates: {
              longitude: feature.longitude,
              latitude: feature.latitude
            }
          },
          links: {
            external_url: feature.url
          }
        }
      end
    end
  end
end