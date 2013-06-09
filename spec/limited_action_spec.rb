require 'spec_helper'

require 'limited'
require 'limited/action'

describe Limited::Action do
  before { @action = Limited::Action.new :do_some_stuff, 1337 }
  subject { @action }

  it { should respond_to(:name) }
  it { should respond_to(:limit) }
  it { should respond_to(:interval) }
  it { should respond_to(:num_executed) }
  it { should respond_to(:num_left) }

  describe "constructor" do
    it "should take a name" do
      name = Limited::Action.new(:do_stuff, 15).name
      name.should eq :do_stuff
    end

    it "should take a limit" do
      limit = Limited::Action.new(:do_stuff, 15).limit
      limit.should eq 15
    end
  end

  describe "name" do
    it "should be a symbol" do
      expect do
        Limited::Action.new "string", 123
      end.to raise_error(ArgumentError)
    end
  end

  describe "limit" do
    it "should be an integer" do
      expect do
        Limited::Action.new :asdasd, nil
      end.to raise_error(ArgumentError)
    end

    it "should be positive" do
      expect do
        Limited::Action.new :asdasd, -1
      end.to raise_error(ArgumentError)
    end
  end

  describe "num_executed" do
    it "should be initialized to 0" do
      @action.num_executed.should eq 0
    end
  end

  describe "executed" do
    before { @action.executed }
    it "should increase the num_executed counter" do
      @action.num_executed.should eq 1
    end
  end

  describe "limit_reached" do
    it "should not be reached when intialized" do
      @action.limit_reached.should be_false
    end
    it "should be true when 'executed' has been called 'limit' times" do
      @action.executed
      @action.limit_reached.should be_false
      1335.times { @action.executed }
      @action.limit_reached.should be_false
      @action.executed
      @action.limit_reached.should be_true
      @action.executed
      @action.limit_reached.should be_true
    end
  end

  describe "with an ending interval" do
    before { @interval_action = Limited::Action.new :ending_interval, 5, :minute }
    it "should be able to reach the limit before the interval ends" do
      @interval_action.limit_reached.should be_false
      @interval_action.executed
      @interval_action.limit_reached.should be_false
    end

    describe "after the limit has been reached" do
      before { 5.times { @interval_action.executed } }
      it { @interval_action.limit_reached.should be_true }

      describe "after the interval passed" do
        before { Time.testing_offset += @interval_action.interval.time_left }
        it "should reset num_executed" do
          @interval_action.num_executed.should be 0
          @interval_action.limit_reached.should be_false
        end
      end
    end
  end
end
