Capistrano::Configuration.instance(:must_exist).load do
  set(:whenever_cmd) { 'whenever' }
  set(:whenever_identifier) { application }

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
