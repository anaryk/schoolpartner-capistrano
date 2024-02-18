set :application, 'schoolpartner'
set :repo_url, 'git@bitbucket.org:schoolpartner/schoolpartner.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :filter, :roles => %w{app}

set :deploy_to, '/var/www/schoolpartner'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{app/config/environment.neon tests/config/tests.local.neon scripts/dev/reload_db_local.sh scripts/demo/refresh_demo_local.sh}

# Default value for linked_dirs is []
set :linked_dirs, %w{generated_files html/files html/tmp/wkpdf log log_application}

set :keep_releases, 3

desc "Setup cache directory permissions"
task :cache_permissions do
	on roles(:app) do
		within release_path do
			execute 'chmod', '-R', '777', 'temp/'
			execute 'chmod', '-R', '777', 'migrations/directives'
		end
	end
end

desc "Migrate databases"
task :migrate_db do
	on roles(:app) do
		within release_path do
			execute 'php', 'migrations/run.php', 'migrate', 'all', release_path
		end
	end
end

desc "Rollback databases"
task :rollback_db do
	on roles(:app) do
		within release_path do
			execute 'php', 'migrations/run.php', 'rollback', 'all', release_path
		end
	end
end

desc "Shutdown supervisord"
task :supervisord_shutdown do
	on roles(:app) do
		within release_path do
			execute 'supervisorctl', 'shutdown'
		end
	end
end

desc "Start supervisord"
task :supervisord_start do
	on roles(:app) do
		within release_path do
			execute 'sh', 'supervisor_restart.sh'
		end
	end
end

# Pokud nebude soubor na serveru exitovat, vytvoří tam prázdný
desc "Checking shared files"
task :check_shared_files do
	on roles(:app) do
		linked_files(shared_path).each do |file|
			execute 'touch', file
		end
	end
end

after "deploy:started", "supervisord_shutdown"

before "deploy:check:linked_files", "check_shared_files"

after "deploy:updated", "cache_permissions"
after "deploy:updated", "migrate_db"

after "deploy:reverted", "cache_permissions"
after "deploy:reverted", "rollback_db"

after "deploy:finished", "supervisord_start"
