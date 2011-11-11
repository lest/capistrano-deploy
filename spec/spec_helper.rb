require 'capistrano'
require 'capistrano/cli'
require 'capistrano-spec'
require 'capistrano-deploy'

module CapistranoDeploy
  module SpecHelper
    def mock_config(new_instance = false, &block)
      if !@config || new_instance
        @config = Capistrano::Configuration.new(:output => StringIO.new)
        @config.extend(Capistrano::Spec::ConfigurationExtension)
        CapistranoDeploy.load_into(@config)
      end

      @config.instance_eval(&block)
    end

    def config
      @config
    end

    def cli_execute(*args)
      config = @config
      cli = Capistrano::CLI.parse(args.flatten).tap do |cli|
        cli.instance_eval do
          (class << self; self; end).send(:define_method, :instantiate_configuration) do |options|
            config
          end
        end
      end

      cli.execute!
    end
  end
end

RSpec.configure do |config|
  config.include CapistranoDeploy::SpecHelper
  config.include Capistrano::Spec::Matchers
end
