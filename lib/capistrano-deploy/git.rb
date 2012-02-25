module CapistranoDeploy
  module Git
    def self.load_into(configuration)
      configuration.load do
        ssh_options[:forward_agent] = true

        set(:application) { repository.slice(/[^\/:]+?(?=\.git$)/) }
        set(:repository) { abort "Please specify repository, set :repository, 'foo'" }
        set :branch, 'master'
        set :enable_submodules, false

        set(:current_revision) { capture("cd #{deploy_to} && git rev-parse HEAD").chomp }

        set :local_branch do
          `git symbolic-ref HEAD 2> /dev/null`.strip.sub('refs/heads/', '')
        end

        namespace :deploy do
          desc 'Setup'
          task :setup, :except => {:no_release => true} do
            run "mkdir -p `dirname #{deploy_to}` && git clone --no-checkout #{repository} #{deploy_to}"
            update
          end

          desc 'Update the deployed code'
          task :update, :except => {:no_release => true} do
            commit = ENV['COMMIT'] || "origin/#{branch}"
            command = ["cd #{deploy_to}", 'git fetch origin', "git reset --hard #{commit}"]
            command += ['git submodule init', 'git submodule -q sync', 'git submodule -q update'] if enable_submodules
            run command.join(' && ')
          end

          desc 'Show pending commits'
          task :pending do
            commit = ENV['COMMIT'] || "origin/#{branch}"
            system("git log --pretty=medium --stat #{current_revision}..#{commit}")
          end
        end
      end
    end
  end
end
