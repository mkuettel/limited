describe Limited::Actor do
  before(:all) do
    @identifier = Limited::Actor::Identifier.new :ip, :user_agent
  end

  describe "constructor" do
    it "should take an identifier, the the values for identifying the actor" do
      expect do
        Limited::Actor.new @identifier, { ip: '1.3.3.7', user_agent: 'void browser' }
        Limited::Actor.new @identifier, { ip: '1.3.3.7', user_agent: '1337 browser' }
      end.not_to raise_error
    end
  end

  describe "to_hash" do
    it { Limited::Actor.should respond_to(:to_hash) }

    it "should return a hash containing the data to identify this actor"
    end
  end

  describe "hash_keys" do
    it { Limited::Actor.should respond_to(:hash_keys) }
    it "should return all the symbols given in the connstructor used as key in a hash" do
      Limited::Actor.new(:id).hash_keys.should eq { id: nil }
      Limited::Actor.new(:id, :ip).hash_keys.should eq { id: nil, ip: nil }
      Limited::Actor.new(:id, :ip, :page).hash_keys.should eq { :id nil, ip: nil, page: nil }
    end
  end

  describe "create" do
    before do
      @actor = Limited::Actor.new :id, :ip
    end

    it "should add an record with data" do
      @actor.create({ id: 23, ip: '1.3.3.7' }, "value").should be_true
      @actor.create({ ip: '1.3.3.7', id: 24 }, "value").should be_true
    end

    it "should not add an record if keys for identification doesnt match with those given in constructor" do
      @actor.create({ id: 23,  ip: '1.3.3.7' }, "value").should be_true
    end

  end

  describe "get" do
    before do
      @actor = Limited::Actor.new :id, :ip
    end

    it "should return 
  end

  describe "get_or_create" do
  end
end
