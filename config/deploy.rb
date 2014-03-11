require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require "rvm/capistrano"

set :rvm_ruby_string, 'ruby-2.1.1@cap_test'
set :rvm_type, :user
set :rvm_autolibs_flag, "enable"
set :rvm_install_with_sudo, true
set :default_branch, "master"
set :application, "cap_test"
set :repository,  "git@github.com:Mikeyheu/cap_test.git"
set :scm, :git
set :deploy_to,    "/home/deployer/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :stages, %w(staging production)
set :default_stage, "staging"
set :user, "deployer"
ssh_options[:forward_agent] = true
ssh_options[:username]      = 'deployer'
# set :rails_env, "production"


# ssh_options[:forward_agent] = true

# default_run_options[:pty] = true

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
after "deploy", "rvm:trust_rvmrc"
after "deploy:finalize_update", 'deploy:symlink_db'
# after 'deploy:setup', 'deploy:install_passenger'
# after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  desc "Symlinks the application.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
  # task :install_passenger, :roles => :app do
  #   run "gem install passenger"
  # end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :deploy do
  # task :start, :roles => :app do
  #   run "cd #{current_path}; bundle exec passenger start -p 5011 -d -e #{rails_env}"
  # end

  # task :stop, :roles => :app do
  #   run "cd #{current_path}; bundle exec passenger stop -p 5011;"
  # end

  # task :restart, :roles => :app do
  #   stop
  #   start
  # end
end