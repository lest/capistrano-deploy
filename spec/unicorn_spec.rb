require 'spec_helper'

describe 'unicorn' do
  before do
    mock_config { use_recipes :unicorn }
  end

  it 'has default unicorn pid' do
    mock_config { set :deploy_to, '/foo/bar' }
    config.unicorn_pid.should == '`cat /foo/bar/tmp/pids/unicorn.pid`'
  end
end
