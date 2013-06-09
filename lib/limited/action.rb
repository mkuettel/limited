module Limited

  # This class represents an action which
  # can be executed a limited amount of
  # times
  class Action
    # a symbol for the name of the action
    attr_reader :name
    # the amount of times the action can be executed
    attr_reader :limit
    # the amount of times the action already has been executed
    attr_reader :num_executed

    ##
    # :call-seq:
    #   Limited::Action.new(name, limit) -> Limited::Action
    #
    # constructor for an action
    #
    # === Example
    #
    #   Limited::Action.new :do_stuff, 1000
    def initialize(name, limit)
      raise ArgumentError.new("Limited::Action::name needs to be a Symbol") unless name.is_a?(Symbol)
      raise ArgumentError.new("Limited::Action::limit needs to be an Integer") unless limit.is_a?(Integer)
      raise ArgumentError.new("Limited::Action::limit needs to be positive") if limit < 0

      @name = name
      @limit = limit
      @num_executed = 0
    end

    ##
    # returns how many times the action can be executed
    # until the given limit is reached
    def num_left
      @limit - @num_executed
    end

    ##
    # should be called everytime
    # the action gets executed
    # so the internal counter is always up-to-date
    def executed
      @num_executed += 1
    end

    ##
    # wheter the limit of executions
    # has been exceeded
    def limit_reached
      @limit <= @num_executed
    end
  end
end
