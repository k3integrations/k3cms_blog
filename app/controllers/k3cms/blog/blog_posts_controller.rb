module K3cms
  module Blog
    class BlogPostsController < K3cms::Blog::BaseController
      load_and_authorize_resource :blog_post, :class => 'K3cms::Blog::BlogPost'

      def index
        @blog_posts = @blog_posts.order('id desc')
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml  => @blog_posts }
          format.json { render :json => @blog_posts }
        end
      end

      def show
        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml  => @blog_post }
          format.json { render :json => @blog_post }
        end
      end

      def new
        respond_to do |format|
          format.html # new.html.erb
          format.xml  { render :xml  => @blog_post }
          format.json { render :json => @blog_post }
        end
      end

      def create
        @blog_post.attributes = params[:k3cms_blog_blog_post]
        @blog_post.author = current_user

        respond_to do |format|
          if @blog_post.save
            format.html do
              #redirect_to(k3cms_blog_blog_post_url(@blog_post),

              redirect_to(k3cms_blog_blog_posts_url(:focus => "##{dom_id(@blog_post)} .editable[data-attribute=title]"),
                          :notice => 'Blog post was successfully created.')
            end
            format.xml  { render :xml => @blog_post, :status => :created, :location => @blog_post }
            format.json { render :nothing =>  true }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @blog_post.errors, :status => :unprocessable_entity }
            format.json { render :nothing =>  true }
          end
        end
      end

      def edit
      end

      def update
        respond_to do |format|
          if @blog_post.update_attributes(params[:k3cms_blog_blog_post])
            format.html { redirect_to(k3cms_blog_blog_post_url(@blog_post), :notice => 'Blog post was successfully updated.') }
            format.xml  { head :ok }
            format.json { render :json => {} }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @blog_post.errors, :status => :unprocessable_entity }
            format.json { render :json => {:error => @blog_post.errors.full_messages.join('<br/>')} }
          end
        end
      end

      def destroy
        @blog_post.destroy
        respond_to do |format|
          #format.html { redirect_to(k3cms_blog_blog_posts_url) }
          format.html { redirect_to k3cms_blog_blog_posts_url }
          format.xml  { head :ok }
          format.json { render :nothing =>  true }
        end
      end

    end
  end
end
