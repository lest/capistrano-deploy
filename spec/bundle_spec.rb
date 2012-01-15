require 'spec_helper'

describe 'bundler' do
  before do
    mock_config do
      use_recipes :bundler
      set :deploy_to, '/foo/bar'
    end
  end

  it 'uses bundler alias for bundle recipe' do
    config.used_recipes.should == [:bundle]
  end
end
