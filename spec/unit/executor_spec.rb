require_relative "spec_helper"

describe YSI::Executor do
  it_behaves_like "an executor"

  describe "working directory" do
    it "runs in the given working directory" do
      working_directory = subject.run_command(["pwd"], working_directory: "/tmp")
      expect(working_directory).to eq(File.join(path_prefix, "/tmp\n")) 
    end

    it "sets back the working directory to the original value" do
      current_working_directory = Dir.pwd
      subject.run_command(["ls"], working_directory: "/tmp")
      expect(Dir.pwd).to eq(current_working_directory)
    end

    it "sets back the working directory to the original value when there is an error" do
      current_working_directory = Dir.pwd
      expect {
        subject.run_command(["ls /IMNOTTHERE"], working_directory: "/tmp")
      }.to raise_error(YSI::AssertionError)
      expect(Dir.pwd).to eq(current_working_directory)
    end
  end
end
