module Limited

  # This class represents an action which
  # can be executed a limited amount of
  # times
  class Action
    # a symbol for the name of the action
    attr_reader :name
    # the amount of times the action can be executed
    attr_reader :limit
    # an object used to distinguish users
    attr_reader :identifier
    # users which have already executed this action
    # they are differenciated by the identifier object
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
    def num_executed(actor_attributes = nil)
      check_new_interval
      return @num_executed unless actor_attributes.is_a?(Hash)
      actor_num_executed(actor_attributes)
    end

    ##
    # returns how many times the action can be executed
    # until the given limit is reached
    def num_left(actor_attributes = nil)
      check_new_interval
      return @limit - @num_executed unless actor_attributes.is_a?(Hash)
      actor_num_left(actor_attributes)
    end

    ##
    # should be called everytime
    # the action gets executed
    # so the internal counter is always up-to-date
    def executed(actor_attributes = nil)
      check_new_interval
      if actor_attributes.is_a?(Hash)
        actor_executed(actor_attributes)
      else
        @num_executed += 1
      end
    end

    ##
    # wheter the limit of executions
    # has been exceeded
    def limit_reached(actor_attributes = nil)
      check_new_interval
      return @limit <= @num_executed unless actor_attributes.is_a?(Hash)
      actor_limit_reached(actor_attributes)
    end

    ##
    # get a user which can execute this
    # action by the attributes
    #
    # if the actor doesn't exist yet it is created
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
        @actors.each do |current_actor|
          current_actor.num_executed = 0
        end
      end
    end

    def actor_num_executed(attributes)
      actor(attributes).num_executed + @num_executed
    end

    def actor_num_left(attributes)
       @limit - actor_num_executed(attributes)
    end

    def actor_executed(attributes)
      actor(attributes).execute
    end

    def actor_limit_reached(attributes)
      @limit <= actor_num_executed(attributes)
    end

  end
end
