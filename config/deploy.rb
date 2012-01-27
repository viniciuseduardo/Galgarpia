require "bundler/capistrano"

set :application, "ecommerce"
set :keep_releases, "3"

# git options
set :scm, "git"
set :repository, "git@github.com:viniciuseduardo/Galgarpia.git"
set :branch, "master"
set :deploy_via, :remote_cache

# deploy credentials
set :user, "root"
set :deploy_to, "/var/www/#{application}"
set :use_sudo, true

# server definitions
set :servers, "178.79.171.141"

role :app, servers
role :web, servers
role :db,  servers, :primary => true

default_run_options[:pty] = true

# working with Passenger
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "don't need #{t} task with mod_rails"
    task t, :roles => :app do
      run "touch #{current_path}/tmp/restart.txt"
    end
  end
end

# Only runs this task after deploy:setup
namespace :init do
  desc "Importa dados Teste"
  task :import_data do
    run "cd  #{current_path}; bundle exec rake RAILS_ENV=production  db:seed"
  end
  desc "Limpar arquivo log"
  task :log_clear do
    run "cd  #{current_path}; bundle exec rake log:clear;"
  end
end

# after "deploy:cold", "init:import_data"
after "deploy", "init:log_clear"