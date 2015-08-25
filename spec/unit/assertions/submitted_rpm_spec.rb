require_relative "../spec_helper.rb"

include GivenFilesystemSpecHelpers

describe YSI::SubmittedRpm do
  use_given_filesystem

  describe "#read_obs_credentials" do
    it "reads OBS credentials" do
      engine = YSI::Engine.new
      a = YSI::SubmittedRpm.new(engine)

      a.read_obs_credentials(given_file("obs/oscrc"))

      expect(a.obs_user).to eq("myuser")
      expect(a.obs_password).to eq("mypassword")
    end
  end

  describe "#create_spec_file" do
    it "processes template" do
      engine = YSI::Engine.new
      a = YSI::SubmittedRpm.new(engine)

      allow(engine).to receive(:project_name).and_return("mycroft")

      engine.version = "0.0.2"
      engine.release_archive = "mycroft-0.0.2.tar.gz"

      expected_spec = <<EOT
# Header of artificial RPM spec file snippet

Name:           go-mycroft
Version:        0.0.2
Release:        0
Source:         mycroft-0.0.2.tar.gz

%prep
%setup -q -n mycroft-0.0.2

%changelog
EOT
      spec = a.create_spec_file(given_file("obs/mycroft.spec.erb"))

      expect(spec).to eq(expected_spec)
    end
  end
end
