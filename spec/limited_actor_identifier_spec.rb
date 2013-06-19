describe Limited::Actor::Identifier do
  before(:all) do
    @identifier = Limited::Actor::Identifier.new
  end
  describe "constructor" do
    it "should take a series of symbols used as keys for identification of the actor" do
      expect do
        Limited::Actor::Identifier.new :id
        Limited::Actor::Identifier.new :id, :ip
        Limited::Actor::Identifier.new :id, :ip, :page
      end.not_to raise_error
    end

    it "should not allow two symbols with the same name" do
      expect { Limited::Actor.new :id, :id }.to raise_error(ArgumentError)
    end
  end

  describe "keys" do
    it { @identifier.should respond_to(:keys) }
    it "should return all the symbols given in the connstructor as an array" do
      Limited::Actor::Identifier.new(:id).keys.should eq [:id]
      Limited::Actor::Identifier.new(:id, :ip).keys.should eq [:id, :ip]
      Limited::Actor::Identifier.new(:id, :ip, :page).keys.should eq [:id, :ip, :page]
    end
  end

  describe "empty_hash" do
    it { @identifier.should respond_to(:hash_keys) }
    it "should return all the symbols given in the connstructor used as key in a hash" do
      Limited::Actor::Identifier.new(:id).hash_keys.should eq({ id: nil })
      Limited::Actor::Identifier.new(:id, :ip).hash_keys.should eq({ id: nil, ip: nil })
      Limited::Actor::Identifier.new(:id, :ip, :page).hash_keys.should eq({ id: nil, ip: nil, page: nil })
    end
  end
end
