module CapistranoDeploy
  module Multistage
    def self.load_into(configuration)
      configuration.load do
        set :multistage_config, Config.new(configuration)

        def define_stage(*args, &block)
          warn "[DEPRECATION] `define_stage` is deprecated, use `stage` instead"
          stage(*args, &block)
        end

        def stage(name, options={}, &block)
          set :default_stage, name.to_sym if options.delete(:default)
          multistage_config.stage(name, options)
          callbacks[:start].detect { |c| c.source == 'multistage:ensure' }.except << name.to_s

          task(name) do
            set :current_stage, name.to_s
            options.each do |k, v|
              set k, v if v
            end
            block.call if block
          end
        end

        namespace :multistage do
          task :ensure do
            unless exists?(:current_stage)
              if stage = multistage_config.inferred_stage
                find_and_execute_task(stage.name)
              elsif exists?(:default_stage)
                find_and_execute_task(default_stage)
              else
                stage_names = multistage_config.stages.map(&:name)
                abort "No stage specified. Please specify one of: #{stage_names.join(', ')} (e.g. `cap #{stage_names.first} #{ARGV.last}')"
              end
            end
          end
        end

        on :start, 'multistage:ensure'
      end
    end

    # Handles multistage configuration
    class Config
      attr_reader :config
      attr_reader :stages

      def initialize(config)
        @config = config
        @stages = []
      end

      def stage(name, options={})
        stages << Stage.new(name, options)
      end

      def inferred_stage
        if config.using_recipe?(:git)
          branch = config.local_branch
          stages.find { |stage| stage.options[:branch].to_s == branch }
        end
      end
    end

    class Stage
      attr_reader :name
      attr_reader :options

      def initialize(name, options={})
        @name    = name
        @options = options
      end
    end
  end
end
