Capistrano::Configuration.instance(:must_exist).load do
  set(:unicorn_pid) { "`cat #{deploy_to}/tmp/pids/unicorn.pid`" }

  namespace :unicorn do
    desc 'Reload unicorn'
    task :reload, :roles => :app, :except => {:no_release => true} do
      run "kill -HUP #{unicorn_pid}"
    end

    desc 'Stop unicorn'
    task :stop, :roles => :app, :except => {:no_release => true} do
      run "kill -QUIT #{unicorn_pid}"
    end
  end
end
