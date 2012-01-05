module RSpec
  module RequestableExamples
    class RequestedExamples < Array
      def initialize(options)
        options ||= {}
        replace options[:examples] || []
      end
  
      def run?(example)
        return true if empty? || include?(example)
        false
      end
    end
    
    def examples_that_can_be_requested
      @examples_that_can_be_requested ||= []
    end
    
    def request_examples(options)
      @requested_examples = RequestedExamples.new(options)
    end
  
    def requested_examples
      @requested_examples
    end
  
    def requestable_example(description, options={}, &blk)
      examples_that_can_be_requested << description
      it description, &blk if requested_examples.run?(options[:as] || description)
    end
    alias_method :requestable_it, :requestable_example
  
    def requestable_examples
      @requestable_examples ||= []
    end
  
    def requestable_describe(description, options={}, &blk)
      label = options[:as] || description
      requestable_examples << label
      describe description, &blk if requested_examples.run?(label)
    end
    alias_method :requestable_context, :requestable_describe
    
    def verify_requested_examples!
      missing_examples = requested_examples - examples_that_can_be_requested
      if missing_examples.any?
        raise %|Trying to request examples that don't exist:\n#{missing_examples.join("\n")}|
      end
    end
  end

end