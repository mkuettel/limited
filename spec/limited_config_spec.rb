require 'limited'
require 'limited/config'

describe Limited::Config do
  it { Limited.should respond_to(:configure) }
  it { Limited::Config.should respond_to(:action) }

  it "should add an Limited::Action to Limited::actions when calling Limited::Config::action" do
    expect do
      Limited::Config.action :new, 123
    end.to change(Limited, :actions)
  end

  it "should not be possible to add an action with the same name twice" do
    expect do
      Limited::Config.action :same_name, 123
      Limited::Config.action :same_name, 123
    end.to raise_error(ArgumentError)
  end

  describe "configure" do
    it "should be possible to add actions via the Limited::configure method" do
      expect do
        Limited.configure do
          action :some_action, 123
        end
      end.to change(Limited, :actions)
    end
  end
end
