Feature: Requestable examples

  Requestable examples are RSpec's shared examples with the addition that you can 
  define examples which you can explicitly request later when you include the 
  requestable example group. Because of this they are a super-set of shared examples.
  
  Requestable example groups can be defined using the following mechanism:
      
      requestable_examples "description goes here" do ; ... ; end
      
  Using this mechanism you have four new methods available to you when writing examples:
  
      requestable_it "name"
      requestable_example "name"
  
      requestable_describe "name"
      requestable_context  "name"
      
  You can mix it/describe/context with the above mechanisms, but when you use the 
  traditional mechanisms those examples will ALWAYS be included. Now, onto using 
  requestable example groups.
  
  Requestable example groups can be included in another group using the same mechanisms
  that you use when using shared example groups, e.g.:
  
      include_examples "name"      # include the examples in the current context
      it_behaves_like "name"       # include the examples in a nested context
      it_should_behave_like "name" # include the examples in a nested context

  If you do not pass in any additional options (see below) then all examples are 
  run. However, if you pass the :examples option with the names of the examples to
  run then the requested examples will only run ones that you've specified!
  
      include_examples "name", :examples => ["example #1"]
      it_behaves_like "name", :examples => ["example #1"]       # include the examples in a nested context
      it_should_behave_like "name", :examples => ["example #1"]
  
  For more information on how to use these see the corresponding scenarios.

  Background:
    Given a file named "spec_helper.rb" with:
      """
        require "../../lib/rspec-requestable-examples"
        RSpec.configure do |config|
          config.extend RSpec::RequestableExamples
        end
      """

  Scenario: Ommitting all examples includes them all
    Given a file named "collection_spec.rb" with:
      """
      require "./spec_helper"
      require "set"

      requestable_examples "a collection with items" do |options|
        let(:collection) { described_class.new([7, 2, 4]) }
        
        requestable_example "is not empty" do
          collection.should_not be_empty
        end

        requestable_it "has more than 0 items" do
          collection.should_not be_empty
        end
      end

      describe Array do
        it_behaves_like "a collection with items"
      end

      describe Set do
        it_behaves_like "a collection with items"
      end
      """
    When I run `rspec collection_spec.rb --format documentation`
    Then the examples should all pass
    And the output should contain:
      """
      Array
        behaves like a collection with items
          is not empty
          has more than 0 items
      
      Set
        behaves like a collection with items
          is not empty
          has more than 0 items
      """

  Scenario: Including specific examples
    Given a file named "collection_spec.rb" with:
      """
      require "./spec_helper"
      require "set"

      requestable_examples "a collection with items" do |options|
        let(:collection) { described_class.new([7, 2, 4]) }
        
        requestable_example "is not empty" do
          collection.should_not be_empty
        end

        requestable_it "has more than 0 items" do
          collection.should_not be_empty
        end
      end

      describe Array do
        it_behaves_like "a collection with items", :examples => [
          "is not empty"
        ] 
      end

      describe Set do
        it_behaves_like "a collection with items", :examples => [
          "has more than 0 items"
        ] 
      end
      """
    When I run `rspec collection_spec.rb --format documentation`
    Then the examples should all pass
    And the output should contain:
      """
      Array
        behaves like a collection with items
          is not empty
      
      Set
        behaves like a collection with items
          has more than 0 items
      """

  Scenario: Traditional "it" and "describe" examples are always run even when not specified
    Given a file named "collection_spec.rb" with:
      """
      require "./spec_helper"
      require "set"

      requestable_examples "a collection with items" do |options|
        let(:collection) { described_class.new([7, 2, 4]) }
        
        it "always runs traditional examples" do
          true.should be_true
        end

        describe "always runs traditional describes" do
          it "is true" do
            true.should be_true
          end
        end
        
        requestable_example "is not empty" do
          collection.should_not be_empty
        end

        requestable_it "has more than 0 items" do
          collection.should_not be_empty
        end
      end

      describe Array do
        it_behaves_like "a collection with items", :examples => []
      end

      describe Set do
        it_behaves_like "a collection with items", :examples => ["is not empty"]
      end
      """
    When I run `rspec collection_spec.rb --format documentation`
    Then the examples should all pass
    And the output should contain:
      """
      Array
        behaves like a collection with items
          always runs traditional examples
          always runs traditional describes
            is true
      
      Set
        behaves like a collection with items
          always runs traditional examples
          is not empty
          always runs traditional describes
            is true
      """


  Scenario: Including aliased examples
    Given a file named "collection_spec.rb" with:
      """
      require "./spec_helper"
      require "set"

      requestable_examples "a collection with items" do |options|
        let(:collection) { described_class.new([7, 2, 4]) }
        
        requestable_example "is not empty", :as => "not empty" do
          collection.should_not be_empty
        end

        requestable_example "has more than 0 items", :as => "contains at least 1 or more items" do
          collection.should_not be_empty
        end
      end

      describe Array do
        it_behaves_like "a collection with items", :examples => [
          "not empty"
        ] 
      end

      describe Set do
        it_behaves_like "a collection with items", :examples => [
          "contains at least 1 or more items"
        ] 
      end
      """
    When I run `rspec collection_spec.rb --format documentation`
    Then the examples should all pass
    And the output should contain:
      """
      Array
        behaves like a collection with items
          is not empty
      
      Set
        behaves like a collection with items
          has more than 0 items
      """

  Scenario Outline: Including specific <type> blocks
    Given a file named "collection_spec.rb" with:
      """
      require "./spec_helper"
      require "set"

      requestable_examples "a collection with items" do |options|
        let(:collection) { described_class.new([7, 2, 4]) }
        
        requestable_<type> "collection rules" do
          it "is not empty" do
            collection.should_not be_empty
          end
        end
      end

      describe Array do
        it_behaves_like "a collection with items", :examples => [
          "collection rules"
        ] 
      end

      describe Set do
        it_behaves_like "a collection with items", :examples => [
          "collection rules"
        ] 
      end
      """
    When I run `rspec collection_spec.rb --format documentation`
    Then the examples should all pass
    And the output should contain:
      """
      Array
        behaves like a collection with items
          collection rules
            is not empty
      
      Set
        behaves like a collection with items
          collection rules
            is not empty
      """
      
    Examples:
      | type     |
      | describe |
      | context  |

  Scenario Outline: Including aliased <type> blocks
    Given a file named "collection_spec.rb" with:
      """
      require "./spec_helper"
      require "set"

      requestable_examples "a collection with items" do |options|
        let(:collection) { described_class.new([7, 2, 4]) }
        
        requestable_<type> "collection rules", :as => "aliased collection rules" do
          it "is not empty" do
            collection.should_not be_empty
          end
        end
      end

      describe Array do
        it_behaves_like "a collection with items", :examples => [
          "aliased collection rules"
        ] 
      end

      describe Set do
        it_behaves_like "a collection with items", :examples => [
          "aliased collection rules"
        ] 
      end
      """
    When I run `rspec collection_spec.rb --format documentation`
    Then the examples should all pass
    And the output should contain:
      """
      Array
        behaves like a collection with items
          collection rules
            is not empty
      
      Set
        behaves like a collection with items
          collection rules
            is not empty
      """
      
    Examples:
      | type     |
      | describe |
      | context  |

  Scenario: Requesting examples that don't exist
    Given a file named "collection_spec.rb" with:
      """
      require "./spec_helper"
      require "set"

      requestable_examples "a collection with items" do |options|
      end

      describe Array do
        it_behaves_like "a collection with items", :examples => [
          "collection rules"
        ] 
      end

      describe Set do
        it_behaves_like "a collection with items", :examples => [
          "collection rules"
        ] 
      end
      """
    When I run `rspec collection_spec.rb --format documentation`
    Then the output should contain "2 examples, 0 failures, 2 pending"
    And the output should contain:
      """
      Array
        behaves like a collection with items
          collection rules (PENDING: This example was requested but isn't defined, typo?)
      
      Set
        behaves like a collection with items
          collection rules (PENDING: This example was requested but isn't defined, typo?)
      """

