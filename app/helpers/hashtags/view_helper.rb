module Hashtags
  module ViewHelper
    def render_help_for(cls, field_name)
      return unless help = cls.hashtags[field_name.to_s].help
      render 'hashtags/help', help: help
    end
  end
end
