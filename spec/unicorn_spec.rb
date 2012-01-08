require 'spec_helper'

describe 'unicorn' do
  before do
    mock_config { use_recipes :unicorn }
  end

  it 'has default unicorn pid' do
    mock_config { set :deploy_to, '/foo/bar' }
    config.unicorn_pid.should == '`cat /foo/bar/tmp/pids/unicorn.pid`'
  end

  context 'signals' do
    before do
      mock_config { set :unicorn_pid, '/foo.pid' }
    end

    it 'sends HUP' do
      cli_execute 'unicorn:reload'
      config.should have_run('kill -HUP /foo.pid')
    end

    it 'sends QUIT' do
      cli_execute 'unicorn:stop'
      config.should have_run('kill -QUIT /foo.pid')
    end

    it 'sends USR2' do
      cli_execute 'unicorn:reexec'
      config.should have_run('kill -USR2 /foo.pid')
    end
  end
end
