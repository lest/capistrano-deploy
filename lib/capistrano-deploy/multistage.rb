Capistrano::Configuration.instance(:must_exist).load do
  set :multistage_stages, []

  def define_stage(name, &block)
    multistage_stages << name
    callbacks[:start].detect { |c| c.source == 'multistage:ensure' }.except << name.to_s
    task(name) do
      set :stage, name
      block.call
    end
  end

  namespace :multistage do
    task :ensure do
      unless exists?(:stage)
        if exists?(:default_stage)
          find_and_execute_task(default_stage)
        else
          abort "No stage specified. Please specify one of: #{multistage_stages.join(', ')} (e.g. `cap #{multistage_stages.first} #{ARGV.last}')"
        end
      end
    end
  end

  on :start, 'multistage:ensure'
end
