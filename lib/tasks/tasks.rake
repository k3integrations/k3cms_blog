namespace :k3cms do
  namespace :blog do
    desc "Install K3cms Blog"
    task :install => [:copy_public, :copy_migrations] do
    end
    
    desc "Copy public files"
    task :copy_public do
      K3cms::FileUtils.copy_or_symlink_files_from_gem K3cms::Blog, 'public/**/*'
    end
    
    desc "Copy migrations"
    task :copy_migrations do
      K3cms::FileUtils.copy_from_gem K3cms::Blog, 'db/migrate'
    end
  end
end
