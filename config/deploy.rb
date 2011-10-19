require "bundler/capistrano"

set :application, "ecomerce"
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

desc "Link in the production database.yml"
task :after_update_code do
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
end

# Only runs this task after deploy:setup
# Used to create a new config/database.yml which differs from the repository
namespace :init do
  desc "Create production-only database.yml"
  task :production_database_yml do
    database_configuration =<<-EOF
production:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: galgarpia_production
  pool: 5
  host: 127.0.0.1
  username: root
  password:
    EOF

    run "mkdir -p #{shared_path}/config"
    put database_configuration, "#{shared_path}/config/database.yml"
  end
  desc "Importa dados Teste"
  task :import_data do
    run "cd  #{current_path}; bundle exec rake RAILS_ENV=production  db:seed"
  end
  desc "Limpar arquivo log"
  task :log_clear do
    run "cd  #{current_path}; bundle exec rake log:clear;"
  end
end

after "deploy:setup", "init:production_database_yml"
after "deploy:cold", "init:import_data"
after "deploy", "init:log_clear"