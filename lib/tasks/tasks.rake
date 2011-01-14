namespace :k3 do
  namespace :blog do
    desc "Install K3 Blog"
    task :install => [:copy_public, :copy_migrations] do
    end
    
    desc "Copy public files"
    task :copy_public do
      K3::FileUtils.copy_from_gem K3::Blog, 'public'
    end
    
    desc "Copy migrations"
    task :copy_migrations do
      K3::FileUtils.copy_from_gem K3::Blog, 'db/migrate'
    end
  end
end
