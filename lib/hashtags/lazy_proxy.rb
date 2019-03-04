module Hashtags
  class LazyProxy < BasicObject
    def self.promise(&callback)
      new(&callback)
    end

    def initialize(&callback)
      @callback = callback
    end

    def method_missing(method, *args, &block)
      __target__.send(method, *args, &block)
    end

    def __target__
      @target ||= @callback.call
    end
  end

  module Kernel
    def promise(&callback)
      LazyProxy.promise(&callback)
    end
  end
end
