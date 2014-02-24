def template(from, to)
  erb= File.read(File.expand_path("../templates/#{from}", __FILE__))
  upload! ERB.new(erb).result(binding), to
end

def set_default(name, value)
	if !(fetch(name)) 
		set(name, value)
	end
end

namespace :deploy do
	task :install do
		on roles (:all) do
			execute :sudo, "apt-get", "-y", "update"
			execute :sudo, "apt-get", "-y", "install", "python-software-properties"
		end
	end
end

