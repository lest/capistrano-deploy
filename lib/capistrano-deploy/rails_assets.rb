module CapistranoDeploy
  module RailsAssets
    def self.load_into(configuration)
      configuration.load do
        use_recipe :rails

        namespace :deploy do
          namespace :assets do
            task :precompile do
              run "cd #{deploy_to} && RAILS_ENV=#{rails_env} RAILS_GROUPS=assets #{rake} assets:precompile"
            end

            task :clean do
              run "cd #{deploy_to} && RAILS_ENV=#{rails_env} RAILS_GROUPS=assets #{rake} assets:clean"
            end
          end
        end

        after 'deploy:update', 'deploy:assets:precompile'
      end
    end
  end
end
