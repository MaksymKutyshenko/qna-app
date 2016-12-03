# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'qna'
set :repo_url, 'git@github.com:MaksymKutyshenko/qna-app.git'
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', '.env', 'config/cable.yml'
# Default value for linked_dirs is []
append :linked_dirs, 'bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # For passenger
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end
