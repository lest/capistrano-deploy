module CapistranoDeploy
  module Unicorn
    def self.load_into(configuration)
      configuration.load do
        set(:unicorn_pid_file) { "#{deploy_to}/tmp/pids/unicorn.pid" }
        set(:unicorn_pid) { "$(cat #{unicorn_pid_file})" }

        namespace :unicorn do
          desc 'Reload unicorn'
          task :reload, :roles => :app, :except => {:no_release => true} do
            run "kill -HUP #{unicorn_pid}"
          end

          desc 'Stop unicorn'
          task :stop, :roles => :app, :except => {:no_release => true} do
            run "kill -QUIT #{unicorn_pid}"
          end

          desc 'Reexecute unicorn'
          task :reexec, :roles => :app, :except => {:no_release => true} do
            run "if [ -e #{unicorn_pid_file} ]; then kill -USR2 #{unicorn_pid}; fi"
          end
        end
      end
    end
  end
end
