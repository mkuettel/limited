require "limited/version"
require "limited/action"
require "limited/interval"
require "limited/actor"

module Limited
  # a hash containing all the 
  # limited actions
  # the name of the Action is used as key
  @actions = {}

  ##
  # returns a hash containing all the 
  # limited actions
  def self.actions
    @actions
  end

  @identifiers = {}

  def self.identifiers
    @identifiers
  end


  ##
  # :call-seq:
  #   Limited.<action_name> -> Limited::Action
  #
  # adds the possibility to access
  # every action directly via Limited.<actionanem>
  #
  # === Example
  #
  #   Limited.configure do
  #     action :some_action, 123
  #   end
  #
  #   Limited.some_action.executed
  #   Limited.some_action.num_left # -> 122
  def self.method_missing(method_id, *arguments)
    if @actions.has_key?(method_id)
      @actions[method_id]
    else
      super
    end
  end
end

require "limited/config"
