Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    desc 'Deploy & migrate'
    task :migrations do
      update
      migrate
      restart
    end

    desc 'Run migrations'
    task :migrate, :roles => :db, :only => {:primary => true} do
      rake = fetch(:rake, 'rake')
      rails_env = fetch(:rails_env, 'production')
      run "cd #{deploy_to} && RAILS_ENV=#{rails_env} #{rake} db:migrate"
    end
  end
end
