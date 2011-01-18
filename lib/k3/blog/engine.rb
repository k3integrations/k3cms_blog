require "rails"
require "k3_blog"
require 'facets/kernel/__dir__'
require 'facets/pathname'

module K3
  module Blog

    class Engine < Rails::Engine
      config.before_configuration do |app|
        # Ensure that friendly_id/railtie is loaded soon enough
        # The Bundler.require(:default, Rails.env) in application.rb *only* *requires* gems listed in the *app*'s Gemfile, not gems that those gems depend on, even though it *installs* those.
        # We could simply list these gems in the app's Gemfile, but they are dependencies of *this* gem, not of the app, so we should handle requiring them here.
        require 'friendly_id'
        require 'stringex'

        # Ensure that active_record is loaded before attribute_normalizer, since attribute_normalizer only loads its active_record-specific code if active_record is loaded.
        require 'active_record'
        require 'attribute_normalizer'
      end

      config.action_view.javascript_expansions[:k3] ||= []
      config.action_view.javascript_expansions[:k3].concat [
        'k3/blog.js',
      ]

      initializer 'k3.blog.add_cells_paths' do |app|
        Cell::Base.view_paths += [Pathname[__DIR__] + '../../../app/cells']
      end

      # Auto-loading doesn't work for this because User is opened in *multiple* different files, so this file would never get loaded.
      config.to_prepare do |app|
        require Pathname[__DIR__] + '../../../app/models/user.rb'
      end
    end

  end
end
