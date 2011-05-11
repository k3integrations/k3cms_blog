$:.unshift File.join(File.dirname(__FILE__), '..')  # so we can require 'app/models/...'

require 'k3cms/blog/railtie' if defined?(Rails)

module K3cms
  module Blog
  end
end
