module K3
  module Blog
    class BlogPostsController < K3::Blog::BaseController
      load_and_authorize_resource :blog_post, :class => 'K3::Blog::BlogPost', :except => :not_found

      def index
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

          format.json {
            # So we have data-object="k3_blog_post" for rest_in_place so that the params come in as params[:k3_blog_post] like the controller expects (and which works well since form_for @blog_post creates fields named that way).
            # But that causes rest_in_place to expect the json object to be in the form {"k3_blog_post":...}
            # But K3::Blog::BlogPost.model_name.element drops the namespace and returns 'blog_post' by default. Here is my workaround:
            K3::Blog::BlogPost.model_name.instance_variable_set('@element', 'k3_blog_post')
            # Other options:
            # * Pass include_root_in_json => false in the as_json options?
            # * ActiveRecord::Base.include_root_in_json = false and do render :json => { :k3_blog_post => @blog_post }
            # * ActiveRecord::Base.include_root_in_json = false and modify rest_in_place to not require/expect the element name to be in the JSON object response.
            render :json => @blog_post
          }
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
        @blog_post.attributes = params[:k3_blog_post]
        @blog_post.author = current_user

        respond_to do |format|
          if @blog_post.save
            format.html { redirect_to(k3_blog_blog_post_url(@blog_post), :notice => 'Blog post was successfully created.') }
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
          if @blog_post.update_attributes(params[:k3_blog_post])
            format.html { redirect_to(k3_blog_blog_post_url(@blog_post), :notice => 'Blog post was successfully updated.') }
            format.xml  { head :ok }
            format.json { render :nothing =>  true }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @blog_post.errors, :status => :unprocessable_entity }
            format.json { render :nothing =>  true }
          end
        end
      end

      def destroy
        @blog_post.destroy
        respond_to do |format|
          format.html { redirect_to(k3_blog_blog_posts_url) }
          format.xml  { head :ok }
          format.json { render :nothing =>  true }
        end
      end

      def last_saved_status
        respond_to do |format|
          format.html { render :text => render_cell('k3/blog/blog_posts', :last_saved_status, :blog_post => @blog_post) }
        end
      end

    end
  end
end
