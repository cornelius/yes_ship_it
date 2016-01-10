require_relative "spec_helper"

describe YSI::Plugin do
  use_given_filesystem

  it "loads plugins" do
    dir = given_directory do
      given_directory "yes_ship_it" do
        given_directory_from_data "assertions", from: "plugins"
      end
    end

    expect(YSI::Plugin.new(dir).load).to eq({
      "my_other_plugin" => YSI::MyOtherPlugin,
      "my_plugin" => YSI::MyPlugin
    })
  end
end
