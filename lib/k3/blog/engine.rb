require "rails"
require "k3_blog"
require 'facets/kernel/__dir__'
require 'facets/pathname'

module K3
  module Blog

    class Engine < Rails::Engine
      config.action_view.javascript_expansions[:k3] ||= []
      config.action_view.javascript_expansions[:k3].concat [
        'k3/blog.js',
      ]

      initializer 'k3.blog.add_cells_paths' do |app|
        Cell::Base.view_paths += [Pathname[__DIR__] + '../../../app/cells']
      end

      config.to_prepare do |app|
        require Pathname[__DIR__] + '../../../app/models/user.rb'
      end
    end

  end
end
