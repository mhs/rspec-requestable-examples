Feature: shared examples

  Requestable shared examples let you describe behavior as a collection of examples that
  you can pick and choose from to run. This is similar to shared examples groups except
  it allows for requesting specific examples or contexts to run.

  Background:
    Given a file named "spec_helper.rb" with:
      """
        require "../../lib/rspec/requestable-examples"
        RSpec.configure do |config|
          config.extend RSpec::RequestableExamples
        end
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

