module Api
  class ListController < ApplicationController
    def index
      feature_id = params[:feature_id]

      # Buscar todos los comentarios asociados al feature_id proporcionado
      comments = Comment.where(earthquake_event_id: feature_id)

      render json: comments, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "No se encontraron comentarios para el feature con ID #{feature_id}" }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end