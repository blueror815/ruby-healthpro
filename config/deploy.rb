# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'prohealth'
set :repo_url, 'git@gitlab.badrit.com:hussein.elsayed/prohealth.git'

# Default branch is :master
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'
set :linked_files, %w(config/database.yml)

set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system )

set(:config_files, %w(
  database.yml
))

# Default value for :scm is :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
  desc "reload the database with seed data"
  task :seed do
    on roles(:app) do |h|
      run_interactively "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{fetch(:rails_env)}", h.user
    end
  end
end

namespace :rails do
  desc "Remote console"
  task :console do
    on roles(:app) do |h|
      run_interactively "bundle exec rails console #{fetch(:rails_env)}", h.user
    end
  end

  desc "Remote dbconsole"
  task :dbconsole do
    on roles(:app) do |h|
      run_interactively "bundle exec rails dbconsole #{fetch(:rails_env)}", h.user
    end
  end

  def run_interactively(command, user)
    info "Running `#{command}` as #{user}@#{host}"
    exec %Q(ssh #{user}@#{host} -t "bash --login -c 'cd #{fetch(:deploy_to)}/current && #{command}'")
  end
end

namespace :logs do
  desc "tail rails logs"
  task :tail_rails do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end

# restart delayed jobs after each deployment
# after 'deploy:publishing', 'deploy:restart'
# namespace :deploy do
#   task :restart do
#     invoke 'delayed_job:restart'
#   end
# end
