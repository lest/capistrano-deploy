module CapistranoDeploy
  module Rvm
    def self.load_into(configuration)
      configuration.load do
        set :rvm_ruby_string, 'default'
        set :rvm_path, '/usr/local/rvm'

        set(:rvm_shell_path) { "#{rvm_path}/bin/rvm-shell" }

        set :default_shell do
          shell = rvm_shell_path
          ruby  = rvm_ruby_string.to_s.strip
          shell = "rvm_path=#{rvm_path} #{shell} '#{ruby}'" unless ruby.empty?

          shell
        end

        if File.exists?('.rvmrc')
          matches = File.read('.rvmrc').scan(/^rvm\s+use\s+.*?([\w\-\.]+@[\w\-]+).*$/)
          if matches.any?
            set :rvm_ruby_string, matches.last.first
          end
        end
      end
    end
  end
end
