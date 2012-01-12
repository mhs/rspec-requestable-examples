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
      label = options[:as] || description
      examples_that_can_be_requested << label
      it description, &blk if requested_examples.run?(label)
    end
    alias_method :requestable_it, :requestable_example
  
    def requestable_examples
      @requestable_examples ||= []
    end
  
    def requestable_describe(description, options={}, &blk)
      label = options[:as] || description
      examples_that_can_be_requested << label
      describe description, &blk if requested_examples.run?(label)
    end
    alias_method :requestable_context, :requestable_describe
    
    def verify_requested_examples!
      missing_examples = requested_examples - examples_that_can_be_requested
      missing_examples.each do |description|
        it description do
          pending("This example was requested but isn't defined, typo?")
        end
      end
    end
  end

end