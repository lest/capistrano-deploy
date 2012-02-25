require 'spec_helper'

describe 'git' do
  before do
    mock_config do
      use_recipe :git
      set :deploy_to, '/foo/bar'
    end

    ENV.delete('COMMIT')
  end

  it 'has branch' do
    config.branch.should == 'master'
  end

  context 'with repository' do
    before do
      mock_config { set :repository, 'git@example.com/test-app.git' }
    end

    it 'sets application from repo' do
      config.application.should == 'test-app'
    end

    describe 'deploy:setup' do
      it 'clones repository' do
        cli_execute 'deploy:setup'
        config.should have_run('mkdir -p `dirname /foo/bar` && git clone --no-checkout git@example.com/test-app.git /foo/bar')
      end

      it 'invokes update during setup' do
        config.namespaces[:deploy].should_receive(:update)
        cli_execute 'deploy:setup'
      end
    end

    describe 'deploy:update' do
      it 'updates' do
        cli_execute 'deploy:update'
        config.should have_run('cd /foo/bar && git fetch origin && git reset --hard origin/master')
      end

      it 'updates submodules' do
        mock_config { set :enable_submodules, true }
        cli_execute 'deploy:update'
        config.should have_run('cd /foo/bar && git fetch origin && git reset --hard origin/master && git submodule init && git submodule -q sync && git submodule -q update')
      end

      it 'updates to specific commit' do
        cli_execute 'deploy:update', 'COMMIT=foobarbaz'
        config.should have_run('cd /foo/bar && git fetch origin && git reset --hard foobarbaz')
      end
    end
  end

  it 'has current revision' do
    config.should_receive(:capture).with('cd /foo/bar && git rev-parse HEAD') { "baz\n" }
    config.current_revision.should == 'baz'
  end

  it 'shows pending' do
    config.should_receive(:current_revision) { 'baz' }
    config.namespaces[:deploy].should_receive(:system).with('git log --pretty=medium --stat baz..origin/master')
    cli_execute 'deploy:pending'
  end

  it 'shows pending against specific commit' do
    config.should_receive(:current_revision) { 'baz' }
    config.namespaces[:deploy].should_receive(:system).with('git log --pretty=medium --stat baz..foobarbaz')
    cli_execute 'deploy:pending', 'COMMIT=foobarbaz'
  end

  it 'sets forward agent' do
    config.ssh_options[:forward_agent].should == true
  end
end
