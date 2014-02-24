namespace :nginx do 
	task :install do
    on roles(:web) do
			execute :sudo, "add-apt-repository", "-y", "ppa:nginx/stable"
			execute :sudo, "apt-get", "-y", "update"
			execute :sudo, "apt-get", "-y", "install", "nginx"
		end
	end
	after "deploy:install", "nginx:install"
	task :setup  do
		on roles(:web) do
			template "nginx_unicorn.erb", "/tmp/nginx_conf"
			execute :sudo, "mv", "/tmp/nginx_conf", "/etc/nginx/sites-enabled/#{fetch(:application)}"
			execute :sudo, "rm", "-f", "/etc/nginx/sites-enabled/default"
		end
	end

	after "deploy:finishing", "nginx:setup"

  [:restart, :stop, :start].each  do |command|
    desc 'Restart application'
    task command do
      on roles(:web) do
        # Your restart mechanism here, for example:
        execute :sudo, "service nginx", "#{command.to_s}" 
      end
    end
  end
  after "nginx:setup", :restart
end