require "rails"
require "k3cms_blog"
require 'facets/kernel/__dir__'
require 'facets/pathname'

module K3cms
  module Blog
    class Engine < Rails::Engine

      config.before_initialize do
        # Work around the fact that the line:
        #   Bundler.require(:default, Rails.env) if defined?(Bundler)
        # in config/application.rb only does a 'require' for the gems explicitly listed in the app's Gemfile -- not for the gems *they* might depend on.
        require 'haml'
        #require 'haml-rails'
        require 'validates_timeliness'
        require 'cancan'
      end

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

      # This is to avoid errors like undefined method `can?' for #<K3cms::Blog::BlogPostCell>
      initializer 'k3.authorization.cancan' do
        ActiveSupport.on_load(:action_controller) do
          include CanCan::ControllerAdditions
          Cell::Base.send :include, CanCan::ControllerAdditions
        end
      end


      config.action_view.javascript_expansions[:k3] ||= []
      config.action_view.javascript_expansions[:k3].concat [
        'k3cms/blog.js',
      ]
      config.action_view.stylesheet_expansions[:k3].concat [
        'k3cms/blog.css',
      ]

      initializer 'k3.blog.cells_paths' do |app|
        Cell::Base.view_paths += [Pathname[__DIR__] + '../../../app/cells']
      end

      initializer 'k3.pages.hooks', :before => 'k3.core.hook_listeners' do |app|
        class K3cms::Blog::Hooks < K3cms::ThemeSupport::HookListener
          insert_after :top_of_page, :file => 'k3cms/blog/init.html.haml'
        end
      end

      # Auto-loading doesn't work for this because User is opened in *multiple* different files, so this file would never get loaded.
      config.to_prepare do |app|
        require Pathname[__DIR__] + '../../../app/models/user.rb'
      end

    end
  end
end
