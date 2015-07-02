shared_examples "an assertion" do
  it "has a display name" do
    expect(assertion.display_name).to be_a(String)
  end
  
  it "checks" do
    expect(assertion).to respond_to(:check)
  end

  it "asserts" do
    expect(assertion).to respond_to(:assert)
  end
end
