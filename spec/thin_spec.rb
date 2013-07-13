require 'spec_helper'

describe 'thin' do
  before do
    mock_config { use_recipes :thin }
    mock_config { set :deploy_to, '/foo/bar' }
  end

  it 'has default params' do
    config.thin_params.should == '-d'
  end

  context 'default command' do
    it 'without bundle recipe' do
      config.thin_command.should == 'thin'
    end

    it 'with bundle recipe' do
      mock_config { use_recipes :bundle }
      config.thin_command.should == 'bundle exec thin'
    end
  end

  context 'tasks' do
    before do
      mock_config { set :thin_params, '-d -p 8080' }
    end

    it 'executes restart' do
      cli_execute 'thin:restart'
      config.should have_run('cd /foo/bar && thin restart -d -p 8080')
    end

    it 'executes stop' do
      cli_execute 'thin:stop'
      config.should have_run('cd /foo/bar && thin stop')
    end

    it 'executes start' do
      cli_execute 'thin:start'
      config.should have_run('cd /foo/bar && thin start -d -p 8080')
    end
  end
end
