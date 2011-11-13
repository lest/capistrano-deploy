require 'spec_helper'

describe 'git' do
  before do
    mock_config { use_recipe :git; set :deploy_to, '/foo/bar' }
  end

  it 'sets application from repo' do
    config.set :repository, 'git@example.com/test-app.git'
    config.application.should == 'test-app'
  end
end
