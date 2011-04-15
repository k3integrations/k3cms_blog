Rails.application.routes.draw do
  resources :k3cms_blog_blog_posts, :path => 'news', :controller => 'k3cms/blog/blog_posts'
end
