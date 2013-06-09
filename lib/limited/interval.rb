module Limited
  ##
  # This represents a timespan within a limit counts
  # after this timespan ends the limit
  # should be reset
  class Interval
    # the length of the interval in seconds
    attr_reader :length
    # a timestamp when the last interval started
    attr_reader :last_start
    
    # common lengths of the intervals
    # and shortcuts for them
    @@interval_lengths = {
      second: 1,
      minute: 60,
        hour: 60 * 60,
         day: 60 * 60 * 24
    }

    ##
    # initializes an interval
    # by either supplying the length of the
    # interval in seconds as an integer
    # or by supplying one of the symbols
    # :second, :minute, :hour or :day
    def initialize(length)
      is_sym = length.is_a?(Symbol) and @@interval_lengths.has_key?(length)
      raise ArgumentError.new("Limited::Interval.length needs to be an Integer or one of the symbols :second, :minute, :hour or :day") unless length.is_a?(Integer) or is_sym
      @length = is_sym ? @@interval_lengths[length] : length
      reset_start
    end

    ##
    # start a new interval and 
    # reset the last_start variable
    def reset_start
      now = Time.now
      @last_start = now - (now.to_i % @length)
    end

    ##
    # calculate the amount of seconds remaining
    # in seconds for the interval to end
    #
    # when the interval ended 0 is returned so
    # this method never returns negative numbers
    def time_left
      [0, (Time.now.to_i - last_start.to_i)].max
    end

    ##
    # wheter the interval has finished
    def passed?
      time_left == 0
    end
  end
end
