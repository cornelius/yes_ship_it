require_relative "spec_helper"

describe "all assertions" do
  [YSI::Version, YSI::ChangeLog, YSI::Tag].each do |assertion_class|
    describe assertion_class do
      it_behaves_like "an assertion" do
        let(:assertion) {assertion_class.new(YSI::Engine.new) }
      end
    end
  end
end
