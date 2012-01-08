require 'spec_helper'

describe 'passenger' do
  before do
    mock_config do
      use_recipe :passenger
      set :deploy_to, '/foo/bar'
    end
  end

  describe 'passenger:restart' do
    it 'touches tmp/restart.txt' do
      cli_execute 'passenger:restart'
      config.should have_run('touch /foo/bar/tmp/restart.txt')
    end

    it 'is executed after deploy:restart' do
      cli_execute 'deploy:restart'
      config.should have_executed('deploy:restart', 'passenger:restart')
    end
  end
end
