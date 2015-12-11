require_relative "../spec_helper.rb"

describe YSI::PublishedGem do
  describe "#assert" do
    it "raises AssertionError if there is an error" do
      engine = YSI::Engine.new
      allow(engine).to receive(:project_name).and_return("IdontExist")
      allow(engine).to receive(:version).and_return("0.0")
      assertion = YSI::PublishedGem.new(engine)

      expect {
        assertion.assert(engine.executor)
      }.to raise_error(YSI::AssertionError)
    end
  end
end
