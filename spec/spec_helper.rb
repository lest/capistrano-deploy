require 'capistrano-deploy'
require 'capistrano/cli'

module CapistranoDeploy
  module Spec
    module ConfigurationExtension
      def run(cmd, options={}, &block)
        runned_commands[cmd] = {:options => options, :block => block}
      end

      def execute_task(task)
        executed_tasks << task.fully_qualified_name
        super
      end

      def runned_commands
        @runned_commands ||= {}
      end

      def executed_tasks
        @executed_tasks ||= []
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
        cli = Capistrano::CLI.parse(args.flatten)
        cli.instance_eval do
          (class << self; self end).send(:define_method, :instantiate_configuration) do |options|
            config
          end
        end

        cli.execute!
      end

      def with_stderr
        original, $stderr = $stderr, StringIO.new
        output = Object.new
        class << output
          instance_methods.each { |m| undef_method m unless m =~ /^__|^object_id$|^instance_eval$/ }
        end
        def output.method_missing(*args, &block)
          ($stderr.rewind && $stderr.read).__send__(*args, &block)
        end

        yield output
      ensure
        $stderr = original
      end
    end

    module Matchers
      extend RSpec::Matchers::DSL

      define :have_run do |cmd|
        match do |configuration|
          configuration.runned_commands[cmd]
        end

        failure_message_for_should do |configuration|
          "expected configuration to run #{cmd}, but it wasn't found in #{configuration.runned_commands.keys}"
        end
      end

      define :have_executed do |*tasks|
        match do |configuration|
          expected = tasks.dup
          configuration.executed_tasks.each do |actual|
            expected.shift if actual == expected.first
          end

          expected.empty?
        end

        failure_message_for_should do |configuration|
          "expected configuration to execute #{tasks}, but it executed #{configuration.executed_tasks.keys}"
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include CapistranoDeploy::Spec::Helper
  config.include CapistranoDeploy::Spec::Matchers
end
