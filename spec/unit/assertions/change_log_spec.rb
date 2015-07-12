require_relative "../spec_helper.rb"

describe YSI::ChangeLog do
  describe "checks content of change log" do
    it "when empty" do
      engine = YSI::Engine.new
      engine.version = "1.2.3"
      a = YSI::ChangeLog.new(engine)
      expect(a.check_content("")).to eq("Can't find version 1.2.3 in change log")
    end

    it "when no version" do
      engine = YSI::Engine.new
      engine.version = "1.2.3"
      a = YSI::ChangeLog.new(engine)
      content = <<EOT
# Change log

## Version 1.0.0

* Some changes
EOT
      expect(a.check_content(content)).to eq("Can't find version 1.2.3 in change log")
    end

    it "when all info is there" do
      engine = YSI::Engine.new
      engine.version = "1.2.3"
      a = YSI::ChangeLog.new(engine)
      content = <<EOT
# Change log

## Version 1.2.3

* Some changes
EOT
      expect(a.check_content(content)).to be_nil
    end
  end

  describe "dependencies" do
    it "#needs?" do
      a = YSI::ChangeLog.new(YSI::Engine)
      expect(a.needs?(:version)).to be(true)
    end

    it "#needs" do
      a = YSI::ChangeLog.new(YSI::Engine)
      expect(a.needs).to eq([:version])
    end
  end
end
