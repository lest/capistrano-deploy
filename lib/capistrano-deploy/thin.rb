module CapistranoDeploy
  module Thin
    def self.load_into(configuration)
      configuration.load do

        namespace :thin do
          set :thin_command do
            using_recipe?(:bundle) ? 'bundle exec thin' : 'thin'
          end

          set :thin_params, '-d'

          desc 'Restart thin'
          task :restart, :roles => :app, :except => {:no_release => true} do
            run "cd #{deploy_to} && #{thin_command} restart #{thin_params}"
          end

          desc 'Stop thin'
          task :stop, :roles => :app, :except => {:no_release => true} do
            run "cd #{deploy_to} && #{thin_command} stop"
          end

          desc 'Start thin'
          task :start, :roles => :app, :except => {:no_release => true} do
            run "cd #{deploy_to} && #{thin_command} start #{thin_params}"
          end
        end
      end
    end
  end
end
