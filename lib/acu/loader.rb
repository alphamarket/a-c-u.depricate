module ACU
  class Loader
    class << self

      def paths
        [
          'acu/errors',
          'acu/helpers',
          'acu/rules',
          'acu/api'
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
