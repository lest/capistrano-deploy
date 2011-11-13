require 'spec_helper'

describe 'deploy' do
  before do
    mock_config { use_recipes :git, :rails }
  end

  it 'returns used recipes' do
    config.used_recipes.should == [:git, :rails]
  end

  it 'checks if recipe is used' do
    config.should be_using_recipe(:git)
    config.should_not be_using_recipe(:bundle)
  end

  describe 'deploy' do
    it 'runs update and restart' do
      config.namespaces[:deploy].should_receive(:update)
      config.namespaces[:deploy].should_receive(:restart)
      cli_execute 'deploy'
    end
  end
end
