require 'spec_helper'

describe 'rails assets' do
  before do
    mock_config do
      use_recipe :rails_assets
      set :deploy_to, '/foo/bar'
    end
  end

  it 'uses rails recipe' do
    config.should be_using_recipe(:rails)
  end

  describe 'deploy:assets:precompile' do
    it 'runs precompile' do
      cli_execute 'deploy:assets:precompile'
      config.should have_run('cd /foo/bar && RAILS_ENV=production RAILS_GROUPS=assets rake assets:precompile')
    end

    it 'uses bundle command' do
      mock_config { use_recipe :bundle }
      cli_execute 'deploy:assets:precompile'
      config.should have_run('cd /foo/bar && RAILS_ENV=production RAILS_GROUPS=assets bundle exec rake assets:precompile')
    end
  end

  describe 'deploy:assets:clean' do
    it 'runs clean' do
      cli_execute 'deploy:assets:clean'
      config.should have_run('cd /foo/bar && RAILS_ENV=production RAILS_GROUPS=assets rake assets:clean')
    end
  end
end
