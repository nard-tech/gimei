class Gimei
  class Config
    attr_accessor :rng

    def initialize(rng: Random)
      @rng = rng
    end

    def blacklist
      @blacklist ||= []
    end

    def blacklist=(blacklist)
      @blacklist = Blacklist.generate(blacklist)
    end
  end
end
