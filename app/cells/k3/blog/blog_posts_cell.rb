module K3
  module Blog
    class BlogPostsCell < Cell::Rails
      helper K3::Ribbon::RibbonHelper # for edit_mode?
      helper K3::InlineEditor::InlineEditorHelper

      # Sorry this is duplicated between here and app/controllers/k3/blog/base_controller.rb
      # I tried refactoring the common code out to a BaseControllerModule module that got mixed in both places, but for whatever reason that I couldn't figure out, it would use the current_ability defined in k3_cancan/lib/cancan/controller_additions.rb:277:
      #   def current_ability
      #     @current_ability ||= ::Ability.new(current_user)
      #   end
      # which references non-existent Ability class.
      #
      def current_ability
        @current_ability ||= K3::Blog::Ability.new(k3_user)
      end

      def published_status
        render
      end

      def index
        @blog_posts = BlogPost.accessible_by(current_ability).order('id desc')
        # This is to enforce the blog_post.published? condition specified in a block. accessible_by doesn't automatically check the block conditions when fetching records.
        @blog_posts.select! {|blog_post| can?(:read, blog_post)}
        render
      end

      def metadata_drawer
        @blog_post = @opts[:blog_post]
        render
      end

    end
  end
end
