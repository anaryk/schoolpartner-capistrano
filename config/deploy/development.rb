settings = "config/local.rb" # local environment configuration
eval File.read(settings)

ask :branch, proc { 'development' }

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{deployer@146.185.168.41}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '146.185.168.41', user: 'deployer', roles: %w{app}


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
set :ssh_options, {
	keys: PATH_TO_KEY,
	auth_methods: %w(publickey),
	user: 'deployer'
}

set :deploy_to, '/var/www/schoolpartner'

desc "Update DB"
task :update_development_db do
	on roles(:app) do
		within release_path do
			if ENV['db']
				execute 'sh', '/var/www/sql-fetch/fetch.sh', "#{ENV['db']}"
			end
		end
	end
end

desc "Import public courses"
task :import_public_courses do
	on roles(:app) do
		within release_path do
			if ENV['import']
				execute 'mysql -u root -p9c7rICKMd9turw== -h 127.0.0.1 -e "DROP DATABASE IF EXISTS demo_sp_caledonian";'
				execute 'mysql -u root -p9c7rICKMd9turw== -h 127.0.0.1 -e "CREATE DATABASE demo_sp_caledonian DEFAULT CHARACTER SET utf8";'
				execute 'mysql -u root -p9c7rICKMd9turw== -h 127.0.0.1 demo_sp_caledonian < /var/www/sql-fetch/2016-09-20/demo_sp_caledonian-16-16-25.sql'
				execute 'php', '/var/www/schoolpartner/current/app/CoursesModule/cli/importer/import.php', "demo_sp_caledonian", "root", "9c7rICKMd9turw=="
			end
		end
	end
end

desc "Restart PHP and MySQL"
task :restart_php_mysql do
	on roles(:app) do
		within release_path do
			execute :sudo, "service", "php7.0-fpm", "restart"
			execute :sudo, "service", "mysql", "restart"
		end
	end
end

after "deploy:started", "update_development_db"
after "deploy:updating", "restart_php_mysql"
after "deploy:finished", "import_public_courses"

#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
