module Limited
  class Actor
    class Identifier

      attr_reader :keys
      attr_reader :hash_keys

      def initialize(*symbols)
        is_symbol_array = symbols.kind_of?(Array)
        symbols.each do |k|
          is_symbol_array = is_symbol_array and k.is_a?(Symbol)
        end
        raise ArgumentError.new("You need to pass a list of symbols") unless is_symbol_array

        raise ArgumentError.new("The symbols passed need to be unique") unless symbols.uniq.size == symbols.uniq.size

        @keys = symbols.sort
        @hash_keys = {}
        @keys.each do |sym|
          @hash_keys[sym] = nil
        end
      end

    end

    attr_reader :attributes
    attr_reader :num_executed

    def initialize(identifier, values, num_executed = 0)
      raise ArgumentError.new("first parameter needs to be an identifier") unless identifier.is_a?(Identifier)
      raise ArgumentError.new("second parameter needs to be a hash of values") unless values.is_a?(Hash)
      raise ArgumentError.new("the values given in the second parameter needs to match with the keys of the identifier") unless identifier.keys.sort == values.keys.sort

      @attributes = values
      @num_executed = num_executed
    end

    def execute
      @num_executed += 1
    end
  end
end
