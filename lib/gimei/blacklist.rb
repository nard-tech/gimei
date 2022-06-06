class Gimei
  class Blacklist
    class << self
      def generate(arg)
        if arg.instance_of?(self)
          arg
        elsif arg.instance_of?(Hash)
          new(arg)
        else
          raise TypeError, "the argument must be a Hash or a instance of Gimei::Blacklist"
        end
      end
    end

    def initialize(arg)
      raise TypeError, "the argument must be a Hash" unless arg.instance_of?(Hash)
    end
  end
end
