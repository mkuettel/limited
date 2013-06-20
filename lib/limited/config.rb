module Limited

  # defines all the functions which
  # can be used to configure
  # this gem
  module Config

    ##
    # adds a new limited action to the list of actions
    # takes the same paramerers as Limited::Action.new
    #
    # raises an ArgumentError if the same name
    # for an action is not unique
    def self.action(name, options = {})
      raise ArgumentError.new("the options parameter needs to be a hash") unless options.is_a?(Hash)
      limit = options[:amount]
      interval = options[:every] || :endless
      identifier = options[:per].is_a?(Symbol) ? Limited::identifiers[options[:per]] : options[:per]
      action = Limited::Action.new(name, limit, interval, identifier)
      raise ArgumentError.new("action with name :#{name.to_s} has already been added") if Limited.actions.has_key?(name)
      Limited.actions[name] = action
    end

    def self.identifier(name, symbols)
      identifier = Limited::Actor::Identifier.new *symbols
      raise ArgumentError.new("identifier with name :#{name.to_s} has already been added") if Limited.identifiers.has_key?(name)
      Limited.identifiers[name] = identifier
    end
  end

  ##
  # executes a block inside Limited::Config
  # so you can easily access the methods in it
  # and configure the Limited gem
  #
  # === Example
  #
  #   Limited.configure do
  #     action :sending_contact_email, 50
  #     action :failed_login, 1337
  #   end
  def self.configure(&block)
    Config.instance_eval &block
  end
end
