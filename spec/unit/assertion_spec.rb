require_relative "spec_helper"

describe YSI::Assertion do
  describe ".class_for_name" do
    it "creates VersionNumber class" do
      expect(YSI::Assertion.class_for_name("version")).
        to be(YSI::Version)
    end

    it "creates ChangeLog class" do
      expect(YSI::Assertion.class_for_name("change_log")).
        to be(YSI::ChangeLog)
    end
  end
end
