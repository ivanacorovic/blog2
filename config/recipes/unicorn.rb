set_default(:unicorn_user, fetch(:user))
set_default(:unicorn_pid, fetch("#{current_path}/tmp/pids/unicorn.pid"))
set_default(:unicorn_config, fetch("#{shared_path}/config/unicorn.rb"))
set_default(:unicorn_log, fetch("#{shared_path}/log/unicorn.log"))
set_default(:unicorn_workers, 2)

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
    on roles (:app) do
      execute "mkdir -p #{shared_path}/config"
      template "unicorn.rb.erb", unicorn_config
      template "unicorn_init.erb", "/tmp/unicorn_init"
      execute "chmod +x /tmp/unicorn_init"
      execute :sudo, "mv", "/tmp/unicorn_init", "/etc/init.d/unicorn_#{fetch(:application)}"
      execute :sudo, "update-rc.d", "-f", "unicorn_#{fetch(:application)} defaults"
    end
  end
  after "deploy:finishing", "unicorn:setup"

   [:restart, :stop, :start].each  do |command|
    desc "#{command} unicorn"
    task command do
       on roles(:web) do
         execute "service unicorn_#{fetch(:application)} #{command.to_s}"
       end
      after "deploy:#{command.to_s}", "unicorn:#{command.to_s}"
    end
  end
end
