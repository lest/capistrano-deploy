require 'spec_helper'

describe 'multistage' do
  before do
    mock_config do
      use_recipes :multistage

      set :default_stage, :development
      stage(:development, :branch => 'develop') { set :foo, 'bar' }
      stage(:production,  :branch => 'master')  { set :foo, 'baz' }
      stage :another_stage, :foo => 'bar'

      task(:example) {}
    end
  end

  it 'uses default stage' do
    cli_execute 'example'
    config.current_stage.should == 'development'
    config.foo.should == 'bar'
  end

  it 'aborts when no stage selected' do
    with_stderr do |output|
      config.unset :default_stage
      expect { cli_execute 'example' }.to raise_error(SystemExit)
      output.should include('No stage specified. Please specify one of: development, production')
    end
  end

  it 'uses specified stage' do
    cli_execute %w[production example]
    config.current_stage.should == 'production'
    config.foo.should == 'baz'
  end

  it 'sets variables from options' do
    cli_execute 'another_stage'
    config.foo.should == 'bar'
  end

  it 'accepts default option' do
    mock_config { stage :to_be_default, :default => true }
    config.default_stage.should == :to_be_default
  end

  context 'with git' do
    before do
      mock_config { use_recipe :git }
    end

    it 'infers stage using local branch' do
      config.stub(:local_branch) { 'master' }
      cli_execute 'example'
      config.current_stage.should == 'production'
      config.branch.should == 'master'
    end

    it 'uses default state when local branch not matches' do
      config.stub(:local_branch) { 'foo' }
      cli_execute 'example'
      config.current_stage.should == 'development'
      config.branch.should == 'develop'
    end
  end
end
