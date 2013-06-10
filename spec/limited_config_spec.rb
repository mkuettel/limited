require 'limited'
require 'limited/config'

describe Limited::Config do
  it { Limited.should respond_to(:configure) }
  it { Limited::Config.should respond_to(:action) }

  it "should add an Limited::Action to Limited::actions when calling Limited::Config::action" do
    expect do
      Limited::Config.action :new, 123, :day
    end.to change(Limited, :actions)
  end

  describe "the Action objects in the Limited::actions array" do
    before(:all) do
      Limited::Config.action :value_check, 123, :day
      Limited::Config.action :value_check1, 3
    end

    it "should have the correct name" do
      Limited.actions[:value_check].name.should eq :value_check
      Limited.actions[:value_check1].name.should eq :value_check1
    end

    it "should have the correct limit" do
      Limited.actions[:value_check].limit.should eq 123
      Limited.actions[:value_check1].limit.should eq 3
    end

    it "should have the correct interval" do
      Limited.actions[:value_check].interval.length.should eq 24 * 60 * 60
      Limited.actions[:value_check1].interval.length.should eq 1.0/0.0
    end
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
