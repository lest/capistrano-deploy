module CapistranoDeploy
  module Passenger
    def self.load_into(configuration)
      configuration.load do
        namespace :deploy do
          desc 'Restart passenger'
          task :restart, :roles => :app, :except => {:no_release => true} do
            run "touch #{deploy_to}/tmp/restart.txt"
          end
        end
      end
    end
  end
end
