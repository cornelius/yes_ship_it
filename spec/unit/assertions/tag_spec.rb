require_relative "../spec_helper"

describe YSI::Tag do
  describe "#get_tag_date" do
    it "gets tag date" do
      engine = YSI::Engine.new
      engine.version = "0.0.2"
      tag = YSI::Tag.new(engine)

      executor = double
      expect(executor).to receive(:run_command).with(["git", "show", "v0.0.2"]).
        and_return("Date:   Tue Jul 14 01:13:16 2015 +0200")

      tag.get_tag_date(executor)

      expect(engine.tag_date).to eq(Time.parse("20150713T231316Z"))
    end
  end

  describe "#check" do
    it "gets an existing tag" do
      expect_any_instance_of(YSI::Executor).to receive(:run_command).
        with(["git", "tag"]).and_return("v0.0.1\nv0.0.2\n")

      engine = YSI::Engine.new
      engine.version = "0.0.2"
      tag = YSI::Tag.new(engine)

      expect(tag).to receive(:get_tag_date)

      tag.check
    end
  end

  describe "#assert" do
    it "creates a tag" do
      engine = YSI::Engine.new
      engine.version = "0.0.2"
      tag = YSI::Tag.new(engine)

      executor = double
      expect(executor).to receive(:run_command).
        with(["git", "tag", "-a", "v0.0.2", "-m", "0.0.2"])
      expect(tag).to receive(:get_tag_date)

      tag.assert(executor)
    end
  end
end
