describe Limited::Interval do
  subject { Limited::Interval }
  it { should respond_to(:length) }
  it { should respond_to(:last_start) }
  it { should respond_to(:time_left) }
  it { should respond_to(:passed?) }


  describe "length" do
     it "should be set by the constructor" do
       i = Interval.new(123)
       i.length.should eq 123
     end

     describe "can also be set via symbols :second, :minute, :hour, :day" do
       it { Interval.new(:second).length.should eq 1 }
       it { Interval.new(:minute).length.should eq 60 }
       it { Interval.new(:hour).length.should eq   60 * 60 }
       it { Interval.new(:day).length.should eq    60 * 60 * 24 }
     end
  end

  describe "time_left" do
    it "should return a value equal or lower than length" do
      Interval.new(541).time_left.should be <= 541
    end
  end

  describe "last_start" do
    it "should be calculated to a time near Time.now which difference is shorter than length" do
      c = Interval.new(100)
      (Time.now - c.last_start).should be <= 100
    end
  end

  describe "passed" do
    let(:i) { Interval.new(541) }
    it "should return false if length seconds have not yet passed" do
      i.passed?.should be_false
      Time.testing_offset += i.time_left - 1
      i.passed?.should be_false
    end

    it "should return true and reset last_start" do
      Time.testing_offset += i.time_left
      i.passed?.should be_true
    end
  end
end
