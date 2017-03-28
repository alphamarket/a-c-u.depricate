module ACU
  module Helpers
    protected
    def pass args = {}
      instance_variable_set("@_params", {}) if not instance_variable_defined?("@_params")
      args.each { |k, v| @_params[k] = v }
      yield
      args.each { |k, _| @_params.delete k }
    end
  end
end