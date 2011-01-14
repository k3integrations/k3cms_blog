$:.unshift File.join(File.dirname(__FILE__), '..')  # so we can require 'app/models/...'

require 'k3/blog/engine'

module K3
  module Blog
  end
end
