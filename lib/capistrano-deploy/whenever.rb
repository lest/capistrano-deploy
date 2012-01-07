module CapistranoDeploy
  module Whenever
    def self.load_into(configuration)
      configuration.load do
        set :whenever_cmd do
          if using_recipe?(:bundle)
            'bundle exec whenever'
          else
            'whenever'
          end
        end

        set :whenever_identifier do
          if using_recipe?(:multistage)
            "#{application}_#{current_stage}"
          else
            application
          end
        end

        namespace :whenever do
          desc 'Update crontab file'
          task :update_crontab, :roles => :db, :only => {:primary => true} do
            run "cd #{deploy_to} && #{whenever_cmd} --update-crontab #{whenever_identifier}"
          end

          desc 'Clear crontab file'
          task :clear_crontab, :roles => :db, :only => {:primary => true} do
            run "cd #{deploy_to} && #{whenever_cmd} --clear-crontab #{whenever_identifier}"
          end
        end
      end
    end
  end
end
