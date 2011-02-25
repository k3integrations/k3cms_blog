Rails.application.routes.draw do
  resources :k3_blog_blog_posts, :path => 'news', :controller => 'k3/blog/blog_posts'
end
