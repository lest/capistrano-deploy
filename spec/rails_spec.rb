require 'spec_helper'

describe 'rails' do
  before do
    mock_config { use_recipe :rails }
  end

  describe 'deploy:migrate' do
    before do
      mock_config { set :deploy_to, '/foo/bar' }
    end

    it 'runs rake db:migrate' do
      cli_execute 'deploy:migrate'
      config.should have_run('cd /foo/bar && RAILS_ENV=production rake db:migrate')
    end

    it 'runs bundle exec db:migrate when using with bundle' do
      mock_config { use_recipe :bundle }
      cli_execute 'deploy:migrate'
      config.should have_run('cd /foo/bar && RAILS_ENV=production bundle exec rake db:migrate')
    end
  end

  describe 'deploy:migrations' do
    it 'runs update, migrate and restart' do
      config.namespaces[:deploy].should_receive(:update)
      config.namespaces[:deploy].should_receive(:migrate)
      config.namespaces[:deploy].should_receive(:restart)
      cli_execute 'deploy:migrations'
    end
  end
end
