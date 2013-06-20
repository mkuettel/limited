module Limited

  # This class represents an action which
  # can be executed a limited amount of
  # times
  class Action
    # a symbol for the name of the action
    attr_reader :name
    # the amount of times the action can be executed
    attr_reader :limit

    attr_reader :identifier

    attr_reader :actors

    ##
    # :call-seq:
    #   Limited::Action.new(name, limit) -> Limited::Action
    #
    # constructor for an action
    #
    # === Example
    #
    #   Limited::Action.new :do_stuff, 1000
    def initialize(name, limit, interval = nil, identifier = [])
      raise ArgumentError.new("Limited::Action::name needs to be a Symbol") unless name.is_a?(Symbol)
      raise ArgumentError.new("Limited::Action::limit needs to be an Integer") unless limit.is_a?(Integer)
      raise ArgumentError.new("Limited::Action::limit needs to be positive") if limit < 0

      @name = name
      @limit = limit
      @num_executed = 0
      @interval = Interval.new(interval.nil? ? :endless : interval)
      @identifier = identifier.is_a?(Limited::Actor::Identifier) ? identifier : Limited::Actor::Identifier.new(*identifier)

      @actors = []
      check_new_interval
    end

    ##
    # returns the interval for which the limit counts
    def interval
      check_new_interval
      @interval
    end

    ##
    # returns the amount of times the action already
    # has been executed
    def num_executed
      check_new_interval
      @num_executed
    end

    ##
    # returns how many times the action can be executed
    # until the given limit is reached
    def num_left
      check_new_interval
      @limit - @num_executed
    end

    ##
    # should be called everytime
    # the action gets executed
    # so the internal counter is always up-to-date
    def executed
      check_new_interval
      @num_executed += 1
    end

    ##
    # wheter the limit of executions
    # has been exceeded
    def limit_reached
      check_new_interval
      @limit <= @num_executed
    end

    def actor(attributes)
      actor = nil
      @actors.each do |current_actor|
        if current_actor.attributes == attributes
          actor = current_actor
        end
      end

      @actors << actor = Limited::Actor.new(@identifier, attributes) if actor.nil?
      actor
    end

    private

    ##
    # checks if the interval
    # passes and resets the number
    # of executions so
    # the limit can be reached again
    def check_new_interval
      if @interval.passed?
        @interval.reset_start
        @num_executed = 0
      end
    end
  end
end
