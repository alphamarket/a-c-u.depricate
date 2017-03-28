module ACU
  class Loader
    class << self

      def paths
        [
          'acu/roles',
          'acu/errors',
          'acu/helpers'
        ]
      end

      def load_paths
        for path in paths
          require path
        end
        @loaded = true
      end

      def loaded?
        @loaded
      end

    end
  end
end
