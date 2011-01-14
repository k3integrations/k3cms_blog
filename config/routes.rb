Rails.application.routes.draw do
  resources :k3_blog_blog_posts, :controller => 'k3/blog/blog_posts' do
    member do
      get :last_saved_status
    end
  end
end
