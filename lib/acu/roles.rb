module ACU
  class Roles
    class << self
      
      protected :new
      
      def initialize
        @namespace = ''
      end
      
      def namespace name
        pass _namespace: name do
          yield
        end
      end
      
      def resource name
        pass _resource: name do
          yield
        end
      end
      
      def action name
        pass _action: name do
          yield
        end
      end
      
      def define(&block)
        self.instance_eval(&block)
      end
      
      ############## the ops ##############
      
      def allow symbol
        puts @_namespace, @_resource, @_action
      end
      
    end
  end
end