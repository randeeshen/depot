require "bundler/capistrano"

set :application, "Rails3Depot"
set :repository,  'clint@clint.webfactional.com:webapps/git/repos/rails3.git'
set :deploy_via, :remote_cache
set :deploy_to, "/home/clint/webapps/depot/depot_app"

set :scm, 'git'
set :branch, 'master'
set :rails_env, 'production'
set :use_sudo, false
set :keep_releases, 4
server 'depot.catsby.net', :app, :web, :db, :primary => true

set :branch, ENV["BRANCH"] if ENV["BRANCH"]

set :default_environment, { 
  'PATH' => "/home/clint/webapps/depot/bin:/home/clint/webapps/grams_on_a_map/bin:/home/clint/bin/:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/clint/bin:/home/clint/.gem/ruby/1.8/bin:/home/clint/webapps/git/bin:/home/clint/webapps/git/bin:/home/clint/bin:/home/clint/.gem/ruby/1.8/bin:/home/clint/webapps/git/bin",
  'GEM_HOME' => '/home/clint/webapps/depot/gems'
}

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end
end



# cleanup
after "deploy:update", "deploy:cleanup"

# update gems

# after "deploy:update_code", :bundle_install
# desc "install the necessary prerequisites"
# task :bundle_install, :roles => :app do
#   run "cd #{release_path} && bundle install"
# end
