describe Limited::Actor do
  before(:all) do
    @identifier = Limited::Actor::Identifier.new :ip, :user_agent
    @actor = Limited::Actor.new @identifier, { ip: '1.3.3.7', user_agent: 'void browser' }
  end

  describe "constructor" do
    it "should take an identifier, the the values for identifying the actor" do
      expect do
        Limited::Actor.new @identifier, { ip: '1.3.3.7', user_agent: 'void browser' }
        Limited::Actor.new @identifier, { ip: '1.3.3.7', user_agent: '1337 browser' }
      end.not_to raise_error
    end

    it "should throw an execption if the values for identifying the actor don't match" do
      expect do
        Limited::Actor.new @identifier, { ip: '1.3.3.7' }
      end.to raise_error(ArgumentError)

      expect do
        Limited::Actor.new @identifier, { ip: '1.3.3.7', user_agent: '123123', stuff: 'asdasd' }
      end.to raise_error(ArgumentError)
    end
  end

  describe "attributes" do
    it { @actor.should respond_to(:attributes) }

    it "should return a hash containing the data to identify this actor" do
      @actor.attributes.should eq({ ip: '1.3.3.7', user_agent: 'void browser' })
    end
  end
end
