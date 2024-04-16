module Api
  class CommentsController < ApplicationController
    before_action :find_feature, only: [:create]
    skip_before_action :verify_authenticity_token, only: [:create] # Agrega esta línea

    def create
      comment = @feature.comments.build(comment_params)

      if comment.save
        render json: comment, status: :created
      else
        render json: { error: "No se pudo crear el comentario", errors: comment.errors }, status: :unprocessable_entity
      end
    end

    private

    def find_feature
      @feature = EarthquakeEvent.find_by(id: params[:feature_id])
      render json: { error: "No se encontró el feature con el ID proporcionado" }, status: :not_found unless @feature
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
  end
end
