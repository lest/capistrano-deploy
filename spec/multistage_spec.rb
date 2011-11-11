require 'spec_helper'

describe 'multistage' do
  before do
    mock_config do
      use_recipes :multistage

      set :default_stage, :development

      define_stage :development do
        set :foo, 'bar'
      end

      define_stage :production do
        set :foo, 'baz'
      end

      task(:example) {}
    end
  end

  it 'uses default stage' do
    cli_execute 'example'
    config.foo.should == 'bar'
  end

  it 'uses specified stage' do
    cli_execute %w[production example]
    config.foo.should == 'baz'
  end
end
