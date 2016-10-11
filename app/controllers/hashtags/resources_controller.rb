module Hashtags
  class ResourcesController < ApplicationController
    def index
      respond_to do |format|
        format.json { render json: resources_as_json, root: false }
      end
    end

    private

    def resources_as_json
      return unless hashtag_class.present?
      @resources_as_json ||= hashtag_class.resources_for_query(query)
    end

    def query
      URI.decode(params.fetch(:q, nil).to_s)
    end

    def hashtag_class
      class_name.safe_constantize
    end

    def class_name
      params[:class_name]
    end
  end
end
