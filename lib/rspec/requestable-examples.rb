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
    
    def request_examples(options)
      @requested_examples = RequestedExamples.new(options)
    end
  
    def requested_examples
      @requested_examples
    end
  
    def requestable_example(description, options={}, &blk)
      requestable_examples << description
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
  end

end