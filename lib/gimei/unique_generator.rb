class Gimei
  class RetryLimitExceeded < StandardError; end

  class UniqueGenerator
    def initialize(max_retries)
      @max_retries = max_retries
      @previous_results = Hash.new { |hash, key| hash[key] = Set.new }
    end

    def clear(key = nil)
      if key
        previous_results(key.to_sym).clear
      else
        previous_results.clear
      end
    end

    %i[name last first address prefecture city town].each do |method_name|
      define_method method_name do
        max_retries.times do
          result = Gimei.public_send(method_name)

          next if previous_results[method_name].include?(result.to_s)

          previous_results[method_name] << result.to_s
          return result
        end

        raise RetryLimitExceeded, "Retry limit exceeded for #{name}"
      end
    end

    private

    attr_reader :max_retries, :previous_results
  end
end
