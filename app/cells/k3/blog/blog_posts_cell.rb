module K3
  module Blog
    class BlogPostsCell < Cell::Rails

      def index
        render
      end

      def last_saved_status
        @blog_post = @opts[:blog_post]
        if @blog_post && !@blog_post.new_record?
          render
        end
      end

    end
  end
end
