module ACU
  module Helpers
    protected
    def pass args = {}
      args.each { |k, v| instance_variable_set("@#{k}", v) }
      yield
      args.each { |k, _| remove_instance_variable("@#{k}") }
    end
  end
end