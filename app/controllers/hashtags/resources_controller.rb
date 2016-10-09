module Hashtags
  class ResourcesController < ApplicationController
    respond_to :json

    def index
      respond_with resources_as_json, root: false
    end

    private

    def resources_as_json
      return unless hash_tag_class
      # @resources_as_json ||= hash_tag_resource_class.as_json(query)
    end

    def hash_tag_class
      Resource.find_by_resource_type(resource_type)
    end

    def query
      URI.decode(params.fetch(:q, nil).to_s)
    end

    def resource_type
      params[:resource_type]
    end
  end
end
