set :application, "freeforms"
set :repository,  "git://github.com/alno/site-freeforms.git"

set :user, "hosting_alno"
set :use_sudo, false
set :deploy_to, "/home/hosting_alno/projects/freeforms"

set :scm, :git

role :web, "hydrogen.locum.ru"
role :app, "hydrogen.locum.ru"
role :db,  "hydrogen.locum.ru", :primary => true

after "deploy:update_code", :bundle_deps
after "deploy:update_code", :copy_database_config

task :bundle_deps, roles => :app do
  run "cd #{release_path} && #{bundle} --path ~/.gem --without development test"
end

task :copy_database_config, roles => :app do
  run "cp #{shared_path}/database.yml #{release_path}/config/database.yml"
end

set :bundle, "/var/lib/gems/1.8/bin/bundle"
set :unicorn_rails, "/var/lib/gems/1.8/bin/unicorn_rails"
set :unicorn_conf, "/etc/unicorn/freeforms.alno.rb"
set :unicorn_pid, "/var/run/unicorn/freeforms.alno.pid"

# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run "cd #{deploy_to}/current && #{bundle} exec #{unicorn_rails} -Dc #{unicorn_conf}"
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || (cd #{deploy_to}/current && #{bundle} exec #{unicorn_rails} -Dc #{unicorn_conf})"
  end
end