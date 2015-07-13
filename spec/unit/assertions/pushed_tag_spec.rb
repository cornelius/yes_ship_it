require_relative "../spec_helper.rb"

describe YSI::PushedTag do
  describe "dependencies" do
    it "#needs?" do
      a = YSI::PushedTag.new(YSI::Engine)
      expect(a.needs?(YSI::Tag)).to be(true)
    end

    it "#needs" do
      a = YSI::PushedTag.new(YSI::Engine)
      expect(a.needs).to eq([YSI::Tag])
    end
  end
end
