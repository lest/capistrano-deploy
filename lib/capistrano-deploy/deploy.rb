Capistrano::Configuration.instance(:must_exist).load do
  ssh_options[:forward_agent] = true

  set(:application) { repository.slice(/[^\/:]+?(?=\.git$)/) }
  set(:repository) { abort "Please specify repository, set :repository, 'foo'" }
  set(:deploy_to) { abort "Please specify deploy directory, set :deploy_to, '/deploy/to/path'" }

  set :branch, 'master'

  set :enable_submodules, false

  set(:current_revision) { capture("cd #{deploy_to} && git rev-parse HEAD").chomp }

  namespace :deploy do
    desc 'Deploy'
    task :default do
      update
      restart
    end

    desc 'Deploy & migrate'
    task :migrations do
      update_code
      migrate
      restart
    end

    desc 'Setup'
    task :setup, :except => {:no_release => true} do
      run "mkdir -p `dirname #{deploy_to}` && git clone --no-checkout #{repository} #{deploy_to}"
      update_code
    end

    desc 'Update'
    task :update do
      update_code
    end

    desc 'Update the deployed code'
    task :update_code, :except => {:no_release => true} do
      command = ["cd #{deploy_to}", 'git fetch origin', "git reset --hard origin/#{branch}"]
      command += ['git submodule init', 'git submodule -q sync', 'git submodule -q update'] if enable_submodules
      run command.join(' && ')
    end

    desc 'Run migrations'
    task :migrate, :roles => :db, :only => {:primary => true} do
      rake = fetch(:rake, 'rake')
      rails_env = fetch(:rails_env, 'production')
      run "cd #{deploy_to} && RAILS_ENV=#{rails_env} #{rake} db:migrate"
    end

    desc 'Restart'
    task :restart do
      # nothing
    end

    desc 'Show pending commits'
    task :pending do
      system("git log --pretty=medium --stat #{current_revision}..origin/#{branch}")
    end
  end
end
