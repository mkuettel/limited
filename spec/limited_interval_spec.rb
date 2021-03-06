require 'spec_helper'
require 'limited'

describe Limited::Interval do
  let(:infinity) { 1.0/0.0 }
  let(:endless) { Limited::Interval.new(:endless) }

  subject { Limited::Interval.new 234 }

  it { should respond_to(:length) }
  it { should respond_to(:last_start) }
  it { should respond_to(:time_left) }
  it { should respond_to(:reset_start) }
  it { should respond_to(:passed?) }


  describe "length" do
     it "should be set by the constructor" do
       i = Limited::Interval.new(123)
       i.length.should eq 123
     end

     describe "can also be set via symbols :second, :minute, :hour, :day" do
       it { Limited::Interval.new(:second ).length.should eq            1 }
       it { Limited::Interval.new(:minute ).length.should eq           60 }
       it { Limited::Interval.new(:hour   ).length.should eq      60 * 60 }
       it { Limited::Interval.new(:day    ).length.should eq 60 * 60 * 24 }
       it {                         endless.length.should eq     infinity }
     end

     it "should raise error when no integer or symbol given" do
       expect { Limited::Interval.new(nil) }.to raise_error(ArgumentError)
     end
  end

  describe "time_left" do
    it "should return a value equal or lower than length" do
      Limited::Interval.new(541).time_left.should be <= 541
    end

    it "should be infinite if interval has the length Infinify" do
      endless.time_left.should eq infinity
    end
  end

  describe "reset_start" do
    it "should be calculated to a time near Time.now which difference is shorter than length" do
      c = Limited::Interval.new(100)
      (Time.now.to_f - c.last_start.to_f).should be <= 100
    end

    it "should set last_start to 0 when interval is endless" do
      endless.last_start.should eq 0
    end
  end

  describe "passed" do
    let(:i) { Limited::Interval.new(541) }
    it "should return false if length seconds have not yet passed" do
      i.passed?.should be_false
      Time.testing_offset += i.time_left - 1
      i.passed?.should be_false
    end

    it "should return true when enough time passed" do
      Time.testing_offset += i.time_left
      i.time_left.should eq 0
      i.passed?.should be_true
    end

    it "should always return false when interval is endless" do
      endless.passed?.should be_false
      Time.testing_offset += i.time_left
      endless.passed?.should be_false
    end
  end
end
