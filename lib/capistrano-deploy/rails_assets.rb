module CapistranoDeploy
  module RailsAssets
    def self.load_into(configuration)
      configuration.load do
        use_recipe :rails
        use_recipe :git

        set(:asset_paths) { ["vendor/assets/", "app/assets/", "lib/assets", "Gemfile", "Gemfile.lock"].join(" ")}

        namespace :deploy do
          namespace :assets do
            desc 'Precompile assets'
            task :precompile do
              if force_asset_compilation? || assets_dirty?
                run "cd #{deploy_to} && RAILS_ENV=#{rails_env} RAILS_GROUPS=assets #{rake} assets:precompile"
              else
                logger.info "Skipping asset pre-compilation because there were no asset changes"
              end                
            end

            desc 'Clean assets'
            task :clean do
              run "cd #{deploy_to} && RAILS_ENV=#{rails_env} RAILS_GROUPS=assets #{rake} assets:clean"
            end
                        
            def force_asset_compilation?
              fetch(:always_compile_assets, false) || ENV['COMPILE_ASSETS'] == 'true'
            end

            def assets_dirty?
              capture("cd #{deploy_to} && git log #{current_revision}..origin/#{branch} #{asset_paths} | wc -l").to_i > 0
            end            
          end
        end
      end
    end
  end
end
