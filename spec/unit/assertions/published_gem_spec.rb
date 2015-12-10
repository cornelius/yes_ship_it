require_relative "../spec_helper.rb"

describe YSI::PublishedGem do
  describe "#assert" do
    it "returns nil if there is an error" do
      engine = YSI::Engine
      allow(engine).to receive(:project_name).and_return("IdontExist")
      allow(engine).to receive(:version).and_return("0.0")
      assertion = YSI::PublishedGem.new(YSI::Engine)

      expect(assertion.assert).to be(nil)
    end
  end
end
