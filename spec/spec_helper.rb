require 'capistrano'
require 'capistrano/cli'
require 'capistrano-deploy'

module CapistranoDeploy
  module Spec
    module ConfigurationExtension
      def run(cmd, options={}, &block)
        runs[cmd] = {:options => options, :block => block}
      end

      def runs
        @runs ||= {}
      end
    end

    module Helper
      def mock_config(new_instance = false, &block)
        if !@config || new_instance
          @config = Capistrano::Configuration.new(:output => StringIO.new)
          @config.extend(CapistranoDeploy::Spec::ConfigurationExtension)
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

    module Matchers
      extend RSpec::Matchers::DSL

      define :have_run do |cmd|
        match do |configuration|
          configuration.runs[cmd]
        end

        failure_message_for_should do |configuration|
          "expected configuration to run #{cmd}, but it wasn't found in #{configuration.runs.keys}"
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include CapistranoDeploy::Spec::Helper
  config.include CapistranoDeploy::Spec::Matchers
end
