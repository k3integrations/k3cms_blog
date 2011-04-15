module K3cms
  module Blog
    class Ability
      include CanCan::Ability

      def initialize(user)
        if user.k3cms_permitted?(:view_blog_post)
          can :read, K3cms::Blog::BlogPost, [] do |blog_post|
            blog_post.published?
          end
        end

        if user.k3cms_permitted?(:edit_blog_post)
          can :read, K3cms::Blog::BlogPost
          can :update, K3cms::Blog::BlogPost
        end

        if user.k3cms_permitted?(:edit_own_blog_post)
          can :read, K3cms::Blog::BlogPost
          can :update, K3cms::Blog::BlogPost, :author_id => user.id
        end

        if user.k3cms_permitted?(:create_blog_post)
          can :create, K3cms::Blog::BlogPost
        end

        if user.k3cms_permitted?(:delete_blog_post)
          can :destroy, K3cms::Blog::BlogPost
        end

        if user.k3cms_permitted?(:delete_own_blog_post)
          can :destroy, K3cms::Blog::BlogPost, :author_id => user.id
        end
      end
    end
  end
end
