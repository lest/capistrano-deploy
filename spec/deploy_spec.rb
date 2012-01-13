require 'spec_helper'

describe 'deploy' do
  before do
    mock_config do
      use_recipes :git, :rails
      set :deploy_to, '/foo/bar'
    end
  end

  it 'returns used recipes' do
    config.used_recipes.should == [:git, :rails]
  end

  it 'checks if recipe is used' do
    config.should be_using_recipe(:git)
    config.should_not be_using_recipe(:bundle)
  end

  it 'uses recipe once' do
    config.use_recipe :git
    config.used_recipes.should == [:git, :rails]
  end

  it 'aborts when recipe name misspelled' do
    with_stderr do |output|
      expect { config.use_recipe(:rvn) }.to raise_error(SystemExit)
      output.should include('Are you misspelled `rvn` recipe name?')
    end
  end

  describe 'deploy' do
    it 'runs update and restart' do
      cli_execute 'deploy'
      config.should have_executed('deploy:update', 'deploy:restart')
    end
  end
end
