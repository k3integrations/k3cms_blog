module K3
  module Blog
    class Ability
      include CanCan::Ability

      def initialize(user)
        alias_action :last_saved_status, :to => :update

        if user.k3_permitted?(:view_blog_post)
          can :read, K3::Blog::BlogPost, [] do |blog_post|
            blog_post.published?
          end
        end

        if user.k3_permitted?(:edit_blog_post)
          can :read, K3::Blog::BlogPost
          can :update, K3::Blog::BlogPost
        end

        if user.k3_permitted?(:edit_own_blog_post)
          can :read, K3::Blog::BlogPost
          can :update, K3::Blog::BlogPost, :author_id => user.id
        end

        if user.k3_permitted?(:create_blog_post)
          can :create, K3::Blog::BlogPost
        end

        if user.k3_permitted?(:delete_blog_post)
          can :destroy, K3::Blog::BlogPost
        end

        if user.k3_permitted?(:delete_own_blog_post)
          can :destroy, K3::Blog::BlogPost, :author_id => user.id
        end
      end
    end
  end
end
