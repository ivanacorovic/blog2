load "config/recipes/base.rb"
load "config/recipes/nginx.rb"
load "config/recipes/unicorn.rb"
load "config/recipes/postgresql.rb"
load "config/recipes/nodejs.rb"
load "config/recipes/rbenv.rb"

set :application, "blog"
set :deploy_to, "/home/deployer/apps/blog"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:ivanacorovic/blog2.git"
set :branch, "master"

set :scm, :git
set :ssh_options, {
  forward_agent: true
}

set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

  task :setup_config do
    on roles(:app) do
      execute :sudo, "ln", "-nfs", "/home/deployer/apps/blog/current/config/recipes/templates/nginx?unicorn.erb", "/etc/nginx/sites-enabled/#{fetch(:application)}"
      execute :sudo, "ln", "-nfs", "/home/deployer/apps/blog/current/config/recipes/templates/unicorn_init.erb", "/etc/init.d/unicorn_#{fetch(:application)}"
      # execute "mkdir -p #{shared_path}/config"
      # put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
      puts "Now edit the config files in #{shared_path}."
    end
  end

after :finishing, "deploy:setup_config"
after "deploy", "deploy:cleanup" # keep only the last 5 releases