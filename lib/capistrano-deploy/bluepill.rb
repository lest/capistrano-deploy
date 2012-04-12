module CapistranoDeploy
  module Bluepill
    def self.load_into(configuration)
      configuration.load do
        set :bluepill_cmd do
          if using_recipe?(:bundle)
            'bundle exec bluepill'
          else
            'bluepill'
          end
        end

        namespace :bluepill do
          desc 'Start bluepill'
          task :start, :roles => :app, :except => {:no_release => true} do
            run "cd #{deploy_to}; #{bluepill_cmd} #{bluepill_flags} load ./config/bluepill.rb"
          end

          desc 'Stop bluepill'
          task :stop, :roles => :app, :except => {:no_release => true} do
            run "cd #{deploy_to}; #{bluepill_cmd} #{bluepill_flags} stop"
          end

          desc 'Restart bluepill'
          task :restart, :roles => :app, :except => {:no_release => true} do
            run "cd #{deploy_to}; #{bluepill_cmd} #{bluepill_flags} restart"
          end

          desc 'Get bluepill status'
          task :status, :roles => :app, :except => {:no_release => true} do
            run "cd #{deploy_to}; #{bluepill_cmd} #{bluepill_flags} status"
          end          
        end
      end
    end
  end
end





