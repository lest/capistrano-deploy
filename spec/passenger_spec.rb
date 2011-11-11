require 'spec_helper'

describe 'passenger' do
  it 'touches tmp/restart.txt' do
    mock_config do
      use_recipes :passenger
      set :deploy_to, '/foo/bar'
    end

    cli_execute 'deploy:restart'
    config.should have_run('touch /foo/bar/tmp/restart.txt')
  end
end
