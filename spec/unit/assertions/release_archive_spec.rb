require_relative "../spec_helper.rb"

describe YSI::ReleaseArchive do
  describe "#check" do
    it "sets engine.release_archive" do
      engine = YSI::Engine.new
      a = YSI::ReleaseArchive.new(engine)
      a.check

      expect(engine.release_archive).to_not be(nil)
    end
  end
end
