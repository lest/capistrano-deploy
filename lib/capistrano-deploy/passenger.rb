Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    desc 'Restart passenger'
    task :restart, :roles => :app, :except => {:no_release => true} do
      run "mkdir -p #{deploy_to}/tmp && touch #{deploy_to}/tmp/restart.txt"
    end
  end
end
