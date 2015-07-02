require_relative "spec_helper"

describe "all assertions" do
  all_classes = ObjectSpace.each_object(Class).select { |klass| klass < YSI::Assertion }

  all_classes.each do |assertion_class|
    describe assertion_class do
      it_behaves_like "an assertion" do
        let(:assertion) {assertion_class.new(YSI::Engine.new) }
      end
    end
  end
end
