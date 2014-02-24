load "config/recipes/base.rb"
load "config/recipes/nginx.rb"
load "config/recipes/unicorn.rb"
load "config/recipes/postgresql.rb"
load "config/recipes/nodejs.rb"
load "config/recipes/rbenv.rb"

set :application, "blog"
set :deploy_to, "/home/deployer/apps/blog"


set :scm, "git"
set :repo_url, "git@github.com:ivanacorovic/blog2.git"
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

