require 'limited'
require 'limited/config'

describe Limited::Config do
  it { Limited.should respond_to(:configure) }
  it { Limited::Config.should respond_to(:action) }

  it "should add an Limited::Action to Limited::actions when calling Limited::Config::action" do
    expect do
      Limited::Config.action :new, amount: 123, every: :day
    end.to change(Limited, :actions)
  end

  describe "the Action objects in the Limited::actions array" do
    before(:all) do
      Limited::Config.identifier :category, [:id]
      Limited::Config.action :value_check, amount: 123, every: :day
      Limited::Config.action :value_check1, amount: 3, per: :category
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

    it "should have the correct identifier" do
      Limited.actions[:value_check].identifier.keys.should eq []
      Limited.actions[:value_check1].identifier.keys.should eq [:id]
    end
  end

  describe "the identifier objects in the Limited::identifiers array" do
    before(:all) do
      Limited.configure do
        identifier :section, [:id]
        action :do_some_task, amount: 2, per: :section
      end
    end

    it "should use the name to store the object" do
      Limited.identifiers[:section].should be_a(Limited::Actor::Identifier)
    end


    it "should contain the symbols passed with the Limited::Config.identifier method" do
      Limited.identifiers[:section].keys.should eq [:id]
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
          action :some_action, amount: 123
        end
      end.to change(Limited, :actions)
    end

    it "should be possible to add identifiers via the Limited::configure method" do
      expect do
        Limited.configure do
          identifier :user, [:user_id]
        end
      end.to change(Limited, :identifiers)
    end
  end
end
