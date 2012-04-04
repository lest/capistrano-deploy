module CapistranoDeploy
  module Foreman
    def self.load_into(configuration)
      configuration.load do
        set :foreman_cmd do
          if using_recipe?(:bundle)
            'bundle exec foreman'
          else
            'foreman'
          end
        end

        set(:rake) { "#{foreman_cmd} run rake" }
        set(:foreman_format) { 'upstart' }

        namespace :foreman do
          desc 'Start foreman'
          task :start, :roles => :app, :except => {:no_release => true} do
            run "cd #{deploy_to}; #{foreman_cmd} start"
          end

          desc 'Export foreman'
          task :export, :roles => :app, :except => {:no_release => true} do
            run "cd #{deploy_to}; #{foreman_cmd} export #{foreman_format} /home/#{user}/service --app=#{app_name} --user=#{user} --log=#{deploy_to}/log"
          end

          desc 'Upload .env file'
          task :upload_env, :roles => :app, :except => {:no_release => true} do
            foreman_env_files = fetch(:foreman_env_files, '.env')        
            files = foreman_env_files.split ','
            env = `cat #{files.join ' '}`
            put env, "#{deploy_to}/.env"
          end
        end

        after 'deploy:update', 'foreman:upload_env'
        after 'deploy:restart', 'foreman:export'
      end
    end
  end
end