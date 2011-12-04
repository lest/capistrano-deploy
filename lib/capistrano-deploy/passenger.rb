module CapistranoDeploy
  module Passenger
    def self.load_into(configuration)
      configuration.load do
        namespace :passenger do
          desc 'Restart passenger'
          task :restart, :roles => :app, :except => {:no_release => true} do
            run "touch #{deploy_to}/tmp/restart.txt"
          end
        end

        after 'deploy:restart', 'passenger:restart'
      end
    end
  end
end
