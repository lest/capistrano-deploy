require 'spec_helper'

describe 'whenever' do
  before do
    mock_config { use_recipe :whenever}
  end

  describe 'whenever_identifier' do
    before do
      mock_config { set :application, 'foo' }
    end

    it 'defaults to application' do
      config.whenever_identifier.should == 'foo'
    end

    it 'default to application with stage when using multistage' do
      mock_config do
        use_recipe :multistage
        set :current_stage, 'bar'
      end
      config.whenever_identifier.should == 'foo_bar'
    end
  end
end
