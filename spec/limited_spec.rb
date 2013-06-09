require 'limited'
require 'limited/action'

describe Limited::Action do
  subject { Limited::Action.new :do_some_stuff, 1337 }

  it { should respond_to(:name) }
  it { should respond_to(:limit) }
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
end
