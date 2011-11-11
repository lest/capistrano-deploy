require 'spec_helper'

describe 'core' do
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
end
