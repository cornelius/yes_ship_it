shared_examples "an assertion" do
  it "initializes with an engine" do
    expect(assertion.engine).to be_a(YSI::Engine)
  end

  it "has a display name" do
    expect(assertion.display_name).to be_a(String)
  end

  it "has a display name as class method" do
    expect(assertion.class.display_name).to be_a(String)
  end

  it "checks" do
    expect(assertion).to respond_to(:check)
  end

  it "asserts" do
    expect(assertion).to respond_to(:assert)
  end
end
