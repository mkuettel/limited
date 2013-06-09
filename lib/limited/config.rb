module Limited

  # defines all the functions which
  # can be used to configure
  # this gem
  module Config

    ##
    # adds a new limited action to the list of actions
    def self.action(name, limit)
      action = Limited::Action.new(name, limit)
      raise ArgumentError.new("action with name :#{name.to_s} has already been added") if Limited.actions.has_key?(name)
      Limited.actions[name] = action
    end
  end

  def self.configure(&block)
    Config.instance_eval &block
  end
end
