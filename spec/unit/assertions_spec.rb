require_relative "spec_helper"

describe "assertions" do
  describe YSI::Version do
    it_behaves_like "an assertion" do
      let(:assertion) { described_class.new(YSI::Engine.new) }
    end
  end
end
