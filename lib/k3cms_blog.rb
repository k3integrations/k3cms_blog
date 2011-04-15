$:.unshift File.join(File.dirname(__FILE__), '..')  # so we can require 'app/models/...'

require 'k3cms/blog/engine'

module K3cms
  module Blog
  end
end
