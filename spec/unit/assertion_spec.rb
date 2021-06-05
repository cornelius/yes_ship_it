require_relative "spec_helper"

describe YSI::Assertion do
  describe ".class_name" do
    it "converts simple name" do
      expect(YSI::Assertion.class_name("simple")).to eq ("Simple")
    end

    it "converts multi-word name" do
      expect(YSI::Assertion.class_name("multi_word")).to eq ("MultiWord")
    end
  end

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

  describe "parameters" do
    module YSI
      class MyAssertion < Assertion
        parameter :some_thing
        parameter :some_other_thing, "default_hello"

        def self.display_name
          "My Assertion"
        end

        def check
        end

        def assert
        end
      end
    end

    it "has methods for parameter" do
      my = YSI::MyAssertion.new(YSI::Engine.new)
      my.some_thing = "hello"
      expect(my.some_thing).to eq("hello")
    end

    it "has default value for parameter" do
      my = YSI::MyAssertion.new(YSI::Engine.new)
      expect(my.some_other_thing).to eq("default_hello")
    end

    it "returns nil when parameter is not set" do
      my = YSI::MyAssertion.new(YSI::Engine.new)
      expect(my.some_thing).to be(nil)
    end

    it "reads parameter from config" do
      config = <<EOT
assertions:
  my_assertion:
    some_thing: world
EOT
      engine = YSI::Engine.new
      engine.read_config(config)
      my = engine.assertions.first

      expect(my.some_thing).to eq("world")
    end
  end
end
