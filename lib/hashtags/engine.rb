module Hashtags
  class Engine < ::Rails::Engine
    engine_name = :hashtags

    I18n.load_path += Dir[Engine.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
