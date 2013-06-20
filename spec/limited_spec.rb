Limited.configure do
  action :missing_method_test, amount: 13
end

describe Limited do
  it { Limited.should respond_to(:actions) }

  describe "missing_method calls" do
    it "should give access to the action object when calling method with its name" do
      action = Limited.actions[:missing_method_test]
      Limited.missing_method_test.should eq action
    end
  end
end
