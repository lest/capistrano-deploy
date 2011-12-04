module CapistranoDeploy
  module Bundle
    def self.load_into(configuration)
      configuration.load do
        namespace :bundle do
          desc 'Install gems'
          task :install, :except => {:no_release => true} do
            bundle_cmd = fetch(:bundle_cmd, 'bundle')
            bundle_flags = fetch(:bundle_flags, '--deployment --quiet')
            bundle_without = [*fetch(:bundle_without, [:development, :test])].compact

            args = [bundle_flags.to_s]
            args << "--without #{bundle_without.join(' ')}" unless bundle_without.empty?

            run "cd #{deploy_to} && #{bundle_cmd} install #{args.join(' ')}"
          end
        end
      end
    end
  end
end
