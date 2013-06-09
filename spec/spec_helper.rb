class Time #:nodoc:
  class <<self
    attr_accessor :testing_offset
    alias_method :real_now, :now
    def now
      real_now + testing_offset
    end
    alias_method :new, :now
  end
end

Time.testing_offset = 0
