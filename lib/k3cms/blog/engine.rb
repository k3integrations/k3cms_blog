require "rails"
require "k3cms_blog"
require 'facets/kernel/__dir__'
require 'facets/pathname'

module K3cms
  module Blog
    class Engine < Rails::Engine
      puts self

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
      initializer 'k3cms.authorization.cancan' do
        ActiveSupport.on_load(:action_controller) do
          include CanCan::ControllerAdditions
          Cell::Base.send :include, CanCan::ControllerAdditions
        end
      end

      config.action_view.javascript_expansions[:k3cms_editing].concat [
        'k3cms/blog.js',
      ]
      config.action_view.stylesheet_expansions[:k3cms].concat [
        'k3cms/blog.css',
      ]

      initializer 'k3cms.blog.cells_paths' do |app|
        Cell::Base.view_paths += [Pathname[__DIR__] + '../../../app/cells']
      end

      initializer 'k3cms.pages.hooks', :before => 'k3cms.core.hook_listeners' do |app|
        class K3cms::Blog::Hooks < K3cms::ThemeSupport::HookListener
          insert_after :top_of_page, :file => 'k3cms/blog/init.html.haml'
        end
      end

      initializer 'k3cms.blog.require_decorators', :after => 'k3cms.core.require_decorators' do |app|
        #puts 'k3cms.blog.require_decorators'
        Dir.glob(config.root + "app/**/*_decorator*.rb") do |c|
          Rails.env.production? ? require(c) : load(c)
        end
      end

    end
  end
end
