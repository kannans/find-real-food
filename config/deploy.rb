# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'find-real-food'


set :repo_url, 'git@github.com:k2b-ramamoorthy/find-real-food.git'

# Default branch is :master
#ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
 set :deploy_to, '/home/deploy/frf'
# Default value for :scm is :git
 set :scm, :git

# Default value for :format is :pretty
 set :format, :pretty

# Default value for :log_level is :debug
 set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
 set :linked_files, %w{config/database.yml config/unicorn.rb}

# Default value for linked_dirs is []
 set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
 set :default_env, {}#{ path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
 set :keep_releases, 5

 set :unicorn_pid, "#{deploy_to}/current/tmp/pids/unicorn.pid"
 set :unicorn_config, "#{deploy_to}/current/config/unicorn.rb"
 set :unicorn_config_path, "#{deploy_to}/current/config/unicorn.rb"

 set :rvm_ruby_version, 'ruby-2.0.0-p576'

namespace :deploy do

  desc 'Stop Unicorn'
  task :stop do
    on roles(:app) do
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        execute :kill, capture(:cat, fetch(:unicorn_pid))
      end
    end
  end

  desc 'Start Unicorn'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec unicorn -E production -c #{fetch(:unicorn_config)} -D"
        end
      end
    end
  end

  desc 'Reload Unicorn without killing master process'
  task :reload do
    on roles(:app) do
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        execute :kill, '-s USR2', capture(:cat, fetch(:unicorn_pid))
        puts "Unicorn reload"
      else
        error 'Unicorn process not running'
      end
    end
  end   

  after "deploy", "deploy:stop"
  after "deploy", "deploy:start"

end
